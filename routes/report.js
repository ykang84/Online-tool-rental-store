var express = require('express');
var router  = express.Router();
var connection = require('../models/model');
var middleware = require('../middleware/index');

router.get('/clerkReport', middleware.isClerkLoggedIn, function (req, res) {
    var clerkSQL = 'SELECT ClerkID, first_name, middle_name, last_name, email, hire_date, 0 AS number_of_pickups, 0 AS number_of_dropoffs,' +
        ' 0 AS total FROM Clerk ORDER BY ClerkID';

    var pickupSQL = 'SELECT ClerkID, COUNT(*) AS number_of_pickups FROM Clerk INNER JOIN Reservation ON PickClerkID = ClerkID' +
        ' WHERE MONTH(start_date) = MONTH(CURDATE()) GROUP BY ClerkID ORDER BY ClerkID';

    var dropoffSQL = 'SELECT ClerkID, COUNT(*) AS number_of_dropoffs FROM Clerk INNER JOIN Reservation ON DropClerkID = ClerkID' +
        ' WHERE MONTH(end_date) = MONTH(CURDATE()) GROUP BY ClerkID ORDER BY ClerkID';

    connection.query(clerkSQL, function (err, result1) {
        if (err) {
            console.log(err);
        } else {
            connection.query(pickupSQL, function (err, result2) {
                if (err) {
                    console.log(err);
                } else {
                    connection.query(dropoffSQL, function (err, result3) {
                        var pickupIndex = 0;
                        var dropoffIndex = 0;
                        for (var i = 0; i < result1.length; i++) {
                            if (pickupIndex < result2.length && result1[i].ClerkID === result2[pickupIndex].ClerkID) {
                                result1[i].number_of_pickups = result2[pickupIndex].number_of_pickups;
                                pickupIndex++;
                            }
                            if (dropoffIndex < result3.length && result1[i].ClerkID === result3[dropoffIndex].ClerkID) {
                                result1[i].number_of_dropoffs = result3[dropoffIndex].number_of_dropoffs;
                                dropoffIndex++;
                            }
                            result1[i].total = result1[i].number_of_dropoffs + result1[i].number_of_pickups;
                        }
                        res.render('clerkReport', {result: result1});
                    });
                }
            });
        }
    });
});


router.get("/customerReport", middleware.isClerkLoggedIn, function (req,res) {

    var q = 'SELECT Customer.CustomerID, first_name, middle_name, last_name, email, CONCAT(area_code, \'-\', phone_number, \'-\', extension) AS Phone, COUNT(Reservation.reservationID) AS total_reservation,  COUNT(AddRes.ToolID) AS total_tools_rented FROM  Customer NATURAL JOIN Phone LEFT OUTER JOIN Reservation ON Customer.CustomerID = Reservation.CustomerID LEFT OUTER JOIN AddRes ON  Reservation.reservationID = AddRes.reservationID WHERE (MONTH(start_date) = (MONTH(CURDATE()) - 1) AND YEAR(start_date) = YEAR(CURDATE())) OR (MONTH(start_date)= 12 AND MONTH(CURDATE()) = 1 AND YEAR(start_date)=(YEAR(CURDATE()) - 1))  GROUP BY Customer.CustomerID;'
    connection.query(q,function (err,results) {
        if (err) {
            console.log(err);
        } else {
            res.render("customerReport",{results:results});
        }
    });
});


router.get('/toolReport', middleware.isClerkLoggedIn, function (req, res) {
    var tool = [];
    res.render("toolReport", {tool: tool});
});

router.post('/toolReport', middleware.isClerkLoggedIn, function (req, res) {


    var q = "SELECT Tool.ToolID, sum(DATEDIFF(end_date, start_date)) AS rentaldays, max(start_date) AS start_date, max(end_date) AS end_date, CURDATE() AS now, original_price, power_source, sub_option, sub_type FROM" +
        " Tool NATURAL LEFT OUTER JOIN (Addres NATURAL JOIN Reservation) WHERE type = ? AND sub_type = ? GROUP BY ToolID, original_price";
    var insert = [req.body.tool_type, req.body.keyword.toLowerCase()];

    if (!req.body.tool_type && req.body.keyword.toLowerCase() !== '') {
        q = "SELECT Tool.ToolID, sum(DATEDIFF(end_date, start_date)) AS rentaldays, max(start_date) AS start_date, max(end_date) AS end_date, CURDATE() AS now, original_price, power_source, sub_option, sub_type FROM" +
            " Tool NATURAL LEFT OUTER JOIN (Addres NATURAL JOIN Reservation) WHERE sub_type = ? GROUP BY ToolID, original_price";
        insert = [req.body.keyword.toLowerCase()];
    } else if (req.body.tool_type !== '' && req.body.keyword.toLowerCase() === '') {
        q = "SELECT Tool.ToolID, sum(DATEDIFF(end_date, start_date)) AS rentaldays, max(start_date) AS start_date, max(end_date) AS end_date, CURDATE() AS now, original_price, power_source, sub_option, sub_type FROM" +
        " Tool NATURAL LEFT OUTER JOIN (Addres NATURAL JOIN Reservation) WHERE type = ?  GROUP BY ToolID, original_price";
        insert = [req.body.tool_type];     
    } else if (req.body.tool_type === '' && req.body.keyword.toLowerCase() ==='') {
        q = "SELECT Tool.ToolID, sum(DATEDIFF(end_date, start_date)) AS rentaldays, max(start_date) AS start_date, max(end_date) AS end_date, CURDATE() AS now, original_price, power_source, sub_option, sub_type FROM" +
            " Tool NATURAL LEFT OUTER JOIN (Addres NATURAL JOIN Reservation) GROUP BY ToolID, original_price";
    }

    q = mysql.format(q, insert);
    connection.query(q, function (err, results) {
        if (err) {
            console.log(err);
        } else {
            var tool = [];

            for (var i = 0; i < results.length; i++) {
                //get ToolID
                var tuple = {};
                tuple.toolid = results[i].ToolID;
                //get current status and date
                if (results[i].end_date && results[i].start_date && results[i].start_date <= results[i].now && results[i].end_date >= results[i].now) {
                    tuple.status = 'rented';
                    tuple.date = results[i].end_date;

                } else {
                    tuple.date = '';
                    tuple.status = 'available';
                }
                //get short description
                if (results[i].power_source.toLowerCase() !== 'manual') {
                    tuple.shortDes = results[i].power_source + ' ' + results[i].sub_option + ' ' + results[i].sub_type;
                } else {
                    tuple.shortDes = results[i].sub_option + ' ' + results[i].sub_type;
                }
                //rental price
                tuple.rental = results[i].original_price * 0.15 * results[i].rentaldays;
                //cost
                tuple.cost = results[i].original_price;
                //profit
                tuple.profit = tuple.rental - tuple.cost;
                tuple.subType = results[i].sub_type;
                //add a tuple
                tool.push(tuple);
            }

            res.render("toolReport", {tool: tool});
        }
    });
})

module.exports = router;

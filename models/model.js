mysql = require("mysql");

var connection = mysql.createConnection({
    host : 'localhost',
    user : 'hbstudent',
    password : 'hbstudent',
    database : 'cs6400_fa17_team055'
});

connection.connect();

module.exports = connection;
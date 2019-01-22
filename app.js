var express       = require("express"),
    app           = express(),
    connection    = require('./models/model'),
    bodyParser    = require("body-parser"),
    passport      = require("passport"),
    LocalStrategy = require("passport-local"),
    path          = require('path');

var indexRoutes           = require("./routes/index"),
    reportRoutes          = require("./routes/report"),
    toolRoutes            = require("./routes/tool"),
    customerProfileRoutes = require("./routes/viewProfile"),
    add_tool              = require("./routes/add_tool"),
    makeReservation       = require("./routes/makeReservation"),
    pickup                = require("./routes/pickup"),
    dropoff               = require("./routes/dropoff");


app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(require("express-session")({
    secret: "CN Dota Best Dota",
    resave: false,
    saveUninitialized: false
}));

app.use(passport.initialize());
app.use(passport.session());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

passport.use(new LocalStrategy({passReqToCallback: true}, function(req, username, password, done) {

    //if customer radio is selected
    if (req.body.userType === 'customer') {

        var q = "SELECT username FROM Customer WHERE username = ?";
        var inserts1 = [username];
        q = mysql.format(q, inserts1);
        connection.query(q, function (err, results) {
            if (err) {
                return done(err);
            }
            if (results.length === 0) {
                return done(null, false, {message : 'new'});
            } else {
                var p = "SELECT CustomerID AS id FROM Customer WHERE username = ? AND password = ?";
                var inserts2 = [username, password];
                p = mysql.format(p, inserts2);
                connection.query(p, function (err, results) {
                   if (err) {
                       return done(err);
                   }
                   if (results.length === 0) {
                       return done(null, false, {message : 'wrong'});
                   } else {
                       results[0].category = 'customer';
                       return done(null, results[0]);
                   }
                });
            }
        });
    } else {
        var w = "SELECT username FROM Clerk WHERE username = ?";
        var inserts3 = [username];
        w = mysql.format(w, inserts3);
        connection.query(w, function (err, results) {
            if (err) {
                return done(err);
            }
            if (results.length === 0) {
                return done(null, false, {message : 'wrong'});
            } else {
                var p = "SELECT ClerkID AS id FROM Clerk WHERE username = ? AND password = ?";
                var inserts2 = [username, password];
                p = mysql.format(p, inserts2);
                connection.query(p, function (err, results) {
                    if (err) {
                        return done(err);
                    }
                    if (results.length === 0) {
                        return done(null, false, {message : 'wrong'});
                    } else {
                        results[0].category = 'clerk';
                        return done(null, results[0]);
                    }
                });
            }
        });
    }
}));

passport.serializeUser(function (user, done) {
    done(null, user);
});
passport.deserializeUser(function (user, done) {
    done(null, user);
});

app.use(indexRoutes);
app.use(reportRoutes);
app.use(customerProfileRoutes);
app.use(toolRoutes);
app.use(add_tool);
app.use(pickup);
app.use(dropoff);
app.use(makeReservation);


app.listen(8080, function(){
    console.log("rent4tool has started!");
});

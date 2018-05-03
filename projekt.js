const express = require('express');
var mysql = require('sync-mysql');
var bodyParser = require('body-parser')
var ejs = require('ejs');
var format = require('string-format');
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;

var urlencodedParser = bodyParser.urlencoded({ extended: false })

const app = express();
app.use(express.static(__dirname + '/public'));

var con = new mysql({
    host: "localhost",
    user: "testyUser",
    password: "MocneHaslo",
    database: "bazaTestow"
});

passport.use(new LocalStrategy({
    usernameField: 'nazwa',
    passwordField: 'haslo',
    // passReqToCallback: true,
    session: false
},
    function (username, password, done) {

        //sparawdzić czy uzytkownik i hasło jest prawidłowe

        return done(null, username);
    }
));
app.use(passport.initialize());
app.use(urlencodedParser);

passport.serializeUser(function (user, done) {
    done(null, user);
});
passport.deserializeUser(function (user, done) {
    done(null, user);
});



var stronaGlowna = function (req, res) {
    var testy = con.query("select nazwa, id from testy");
    var model = {
        tytul: 'Strona główna',
        testy: testy
    }
    ejs.renderFile("Views\\home.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
}

var dodajTest = function (req, res) {
    ejs.renderFile("Views\\edytuj.ejs", {}, function (err, str) { if (err) throw err; res.send(str); })
}

var zapiszTest = function (req, res) {
    var id = con.query(format("insert into testy (nazwa) values ('{0}')", req.body.nazwa)).insertId;
    res.redirect(format('/dodajPytanie/{0}', id));
}

var dodajPytanie = function (req, res) {
    var model = {
        idTestu: req.params.id
    }
    ejs.renderFile("Views\\dodajPytanie.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
}

var zapiszPytanie = function (req, res) {

    con.query(format("insert into pytania (id_testu, tresc) values ({0},'{1}')", req.body.idTestu, req.body.tresc));
    res.redirect(format('/dodajPytanie/{0}', req.body.idTestu));
}

var usunTest = function(req, res){
    con.query(format("delete from testy where id={0}",req.params.idTestu));
    res.redirect(format('/'));
}


var logowanie = function (req, res) {
    var model = {};

    ejs.renderFile("Views\\logowanie.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
}

app.get('/', stronaGlowna);
app.get('/test/:id', (req, res) => res.send('tu bedą wyniki testu nr' + req.params.id));
app.get('/dodajPytanie/:id', dodajPytanie);
app.get('/dodajTest', dodajTest);
app.post('/zapisz', urlencodedParser, zapiszTest);
app.post('/zapiszPytanie', urlencodedParser, zapiszPytanie);
app.get('/logowanie', logowanie)
app.get('/usunTest/:idTestu',usunTest);
app.post('/login',

    passport.authenticate('local', { failureRedirect: '/logowanie' }),
    function (req, res) {
        console.log('login');
        res.redirect('/');
    });

app.listen(8080, () => console.log('Example app listening on port 8080!'));
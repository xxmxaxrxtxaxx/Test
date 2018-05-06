const express = require('express');
const mysql = require('sync-mysql');
const bodyParser = require('body-parser')
const ejs = require('ejs');
const format = require('string-format');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const session = require('express-session');

const urlencodedParser = bodyParser.urlencoded({ extended: false })

const app = express();
app.use(express.static(__dirname + '/public'));

const con = new mysql({
    host: "localhost",
    user: "testyUser",
    password: "MocneHaslo",
    database: "bazaTestow"
});

const sess = {
    secret: "tajny_klucz",
    resave: false,
    saveUninitialized: true,
};


passport.use(new LocalStrategy({
    usernameField: 'nazwa',
    passwordField: 'haslo',
    session: true
},
    function (username, password, done) {
        var uzytkownicy = con.query(format("SELECT nazwa, haslo, czy_wykladowca, numer_indeksu, kierunek FROM uzytkownicy WHERE nazwa = '{0}'", username));
        if (uzytkownicy.length > 0) {
            if (uzytkownicy[0].haslo == password) {
                return done(null, uzytkownicy[0]);
            }
        }
        return done(null, false);
    }
));
app.use(urlencodedParser);
app.use(session(sess));
app.use(passport.initialize());
app.use(passport.session());

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
        testy: testy,
        uzytkownik: req.user.nazwa
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

var usunTest = function (req, res) {
    con.query(format("delete from testy where id={0}", req.params.idTestu));
    res.redirect(format('/'));
}


var logowanie = function (req, res) {
    var model = {};

    ejs.renderFile("Views\\logowanie.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
}

var czyZalogowany = (req, res, next) => {
    //na potrzeby testów można na sztywno ustawić użytkownika, żeby nie trzeba było się cały czas logować. 
    //Trzeba tylko od komentować linię  poniżej
    //req.user= {nazwa:'zenek',haslo:'test',czy_wykladowca:0,numer_indeksu:1234,kierunek:'przyra'}

    if (!req.isAuthenticated()) {
        return res.redirect('/logowanie');
    }
    return next();
};

var wyloguj = function (req, res) {
    req.logout();
    res.redirect('/logowanie');
};

app.get('/', czyZalogowany, stronaGlowna);
app.get('/test/:id', (req, res) => res.send('tu bedą wyniki testu nr' + req.params.id));
app.get('/dodajPytanie/:id', czyZalogowany, dodajPytanie);
app.get('/dodajTest', czyZalogowany, dodajTest);
app.post('/zapisz', czyZalogowany, zapiszTest);
app.post('/zapiszPytanie', czyZalogowany, zapiszPytanie);
app.get('/logowanie', logowanie)
app.get('/wyloguj', czyZalogowany, wyloguj);
app.get('/usunTest/:idTestu', czyZalogowany, usunTest);
app.post('/login',
    passport.authenticate('local', { failureRedirect: '/logowanie' }),
    function (req, res) {
        res.redirect('/');
    });

app.listen(8080, () => console.log('Example app listening on port 8080!'));
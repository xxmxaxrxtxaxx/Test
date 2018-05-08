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
        var uzytkownicy = con.query(format("SELECT nazwa, imie, nazwisko, haslo, czy_wykladowca, numer_indeksu, kierunek FROM uzytkownicy WHERE nazwa = '{0}'", username));
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
        uzytkownik: req.user.imie,
        czy_wykladowca: req.user.czy_wykladowca
    }
    if (req.user.czy_wykladowca == 1) {
        ejs.renderFile("Views\\home.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
    else {
        ejs.renderFile("Views\\homeStudent.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
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

    var id=con.query(format("insert into pytania (id_testu, tresc, ilosc_pkt) values ({0},'{1}',{2})", req.body.idTestu, req.body.tresc, req.body.punkty)).insertId;
    if(req.body.wariant_0){
        con.query(format("insert into warianty (tresc, id_pytania, czy_poprawny) values ('{0}',{1},{2})",
     req.body.wariant_0, id, (req.body.prawidlowa_odpowiedz==0?1:0)));
     }
     if(req.body.wariant_1){
        con.query(format("insert into warianty (tresc, id_pytania, czy_poprawny) values ('{0}',{1},{2})",
     req.body.wariant_1, id, (req.body.prawidlowa_odpowiedz==1?1:0)));
     }
     if(req.body.wariant_2){
        con.query(format("insert into warianty (tresc, id_pytania, czy_poprawny) values ('{0}',{1},{2})",
     req.body.wariant_2, id, (req.body.prawidlowa_odpowiedz==2?1:0)));
     }
     if(req.body.wariant_3){
        con.query(format("insert into warianty (tresc, id_pytania, czy_poprawny) values ('{0}',{1},{2})",
     req.body.wariant_3, id, (req.body.prawidlowa_odpowiedz==3?1:0)));
     }
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
    req.user = { nazwa: 'zenek', imie: 'z', nazwisko: 'n', haslo: 'test', czy_wykladowca: 0, numer_indeksu: 1234, kierunek: 'przyra' }

    if (!req.isAuthenticated()) {
        return res.redirect('/logowanie');
    }
    return next();
};

var wyloguj = function (req, res) {
    req.logout();
    res.redirect('/logowanie');
};

var wyniki = function (req, res) {
    var rozwiazania = con.query(format("select rozwiazania.id,  from rozwiazania where id_testu={0}", req.params.idTestu));
    var model = {
        rozwiazainia: rozwiazania,
    }
    ejs.renderFile("Views\\wyniki.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
};
var rozpocznijTest = function (req, res) {
    var rozwiazanie = con.query(format("select id from rozwiazania where id_testu={0} and nazwa_uzutkownika='{1}'", req.params.idTestu, req.user.nazwa));
    if (rozwiazanie.length > 0) {
        //test rozwiązany
        res.redirect('/');
    }
    else {
        con.query(format("insert into rozwiazania (nazwa_uzutkownika, czas_rozpoczecia, id_testu) values ('{0}', now(), {1})", req.user.nazwa, req.params.idTestu));
        var idPierwszegoPytania = con.query(format("select id from pytania where id_testu={0}", req.params.idTestu))[0].id;
        res.redirect(format('/odpowiedz/{0}', idPierwszegoPytania));
    }
}
var odpowiedz = function (req, res) {
    var pytanie = con.query(format("select tresc, id, ilosc_pkt from pytania where id={0}", req.params.idPytania))[0];
    var warianty = con.query(format("select id, tresc from warianty where id_pytania={0}", req.params.idPytania));
    if (warianty.length > 0) {
        //pytanie zamkniete
        var model = {
            pytanie: pytanie,
            warianty: warianty

        }
        ejs.renderFile("Views\\zamkniete.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
    else {
        //pytanie otwarte
        var model = {
            pytanie: pytanie
        }
        ejs.renderFile("Views\\opisowe.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
}

var zapiszOdpowiedz = function (req, res) {
    con.query(format("insert into odpowiedzi (nazwa_uzutkownika, id_testu) values ({0},'{1}')", req.body.idTestu, req.body.tresc));
    res.redirect(format('/', req.body.idTestu));
}



app.get('/', czyZalogowany, stronaGlowna);
app.get('/wyniki/:idTestu', czyZalogowany, wyniki);
app.get('/dodajPytanie/:id', czyZalogowany, dodajPytanie);
app.get('/dodajTest', czyZalogowany, dodajTest);
app.post('/zapisz', czyZalogowany, zapiszTest);
app.post('/zapiszPytanie', czyZalogowany, zapiszPytanie);
app.get('/logowanie', logowanie)
app.get('/wyloguj', czyZalogowany, wyloguj);
app.get('/usunTest/:idTestu', czyZalogowany, usunTest);
app.get('/rozpocznijTest/:idTestu', czyZalogowany, rozpocznijTest);
app.get('/odpowiedz/:idPytania', czyZalogowany, odpowiedz);
app.post('/zapiszOdpowiedz', czyZalogowany, zapiszOdpowiedz);

app.post('/login',
    passport.authenticate('local', { failureRedirect: '/logowanie' }),
    function (req, res) {
        res.redirect('/');
    });

app.listen(8080, () => console.log('Example app listening on port 8080!'));
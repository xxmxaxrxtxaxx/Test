const express = require('express');
const mysql = require('sync-mysql');
const bodyParser = require('body-parser')
const ejs = require('ejs');
const format = require('string-format');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const session = require('express-session');
const fileUpload = require('express-fileupload');

const urlencodedParser = bodyParser.urlencoded({ extended: true })

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
app.use(fileUpload());

passport.serializeUser(function (user, done) {
    done(null, user);
});
passport.deserializeUser(function (user, done) {
    done(null, user);
});


var stronaGlowna = function (req, res) {

    if (req.user.czy_wykladowca == 1) {
        var testy = con.query("select nazwa, id from testy");
        var model = {
            tytul: 'Strona główna',
            testy: testy,
            uzytkownik: req.user.imie,
            czy_wykladowca: req.user.czy_wykladowca
        }
        ejs.renderFile("Views\\home.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
    else {
        var testy = con.query(format("select t.nazwa, r.ilosc_zdobytych_pkt, r.ocena, r.id, t.id as id_testu, r.ocena, r.ilosc_zdobytych_pkt from test_studenta ts join testy t on t.id = ts.id_testu left join rozwiazania r on(ts.id_testu=r.id_testu and ts.nazwa_uzytkownika = r.nazwa_uzutkownika) where ts.nazwa_uzytkownika = '{0}' ",  req.user.nazwa));

        var model = {
            tytul: 'Strona główna',
            testy: testy,
            uzytkownik: req.user.imie,
            czy_wykladowca: req.user.czy_wykladowca,

        }
        ejs.renderFile("Views\\homeStudent.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
}

var dodajTest = function (req, res) {
    ejs.renderFile("Views\\edytuj.ejs", {}, function (err, str) { if (err) throw err; res.send(str); })
}

var zapiszTest = function (req, res) {
    var id = con.query(format("insert into testy (nazwa,kierunek,czas_na_rozw_min) values ('{0}','{1}',{2})"
        , req.body.nazwa, req.body.przedmiot, req.body.czas)).insertId;

    if(req.body.recznie){

        res.redirect(format('/dodajPytanie/{0}', id));
    }else{
        var losowePytania = con.query(format("select id from archiwum order by rand() limit {0}", req.body.ilosc_pytan));
        losowePytania.forEach(pytanie => {
            con.query(format("insert into pytania (id_testu, id_archiwum) values ({0},{1})", id, pytanie.id));
        });
    }
}

var dodajPytanie = function (req, res) {
    var model = {
        idTestu: req.params.id,
        archiwalne: con.query("select id, tresc from archiwum")
    }
    ejs.renderFile("Views\\dodajPytanie.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
}

var zapiszPytanie = function (req, res) {
    var id_archiwum = req.body.id_archiwum;
    if(req.body.typ != 'archiwum'){
        var id_archiwum = con.query(format("insert into archiwum (tresc, ilosc_pkt) values ('{0}',{1})", req.body.tresc, req.body.punkty)).insertId;
        if (req.body.wariant_0) {
            con.query(format("insert into warianty (tresc, id_archiwum, czy_poprawny) values ('{0}',{1},{2})",
                req.body.wariant_0, id_archiwum, (req.body.prawidlowa_odpowiedz == 0 ? 1 : 0)));
        }
        if (req.body.wariant_1) {
            con.query(format("insert into warianty (tresc, id_archiwum, czy_poprawny) values ('{0}',{1},{2})",
                req.body.wariant_1, id_archiwum, (req.body.prawidlowa_odpowiedz == 1 ? 1 : 0)));
        }
        if (req.body.wariant_2) {
            con.query(format("insert into warianty (tresc, id_archiwum, czy_poprawny) values ('{0}',{1},{2})",
                req.body.wariant_2, id_archiwum, (req.body.prawidlowa_odpowiedz == 2 ? 1 : 0)));
        }
        if (req.body.wariant_3) {
            con.query(format("insert into warianty (tresc, id_archiwum, czy_poprawny) values ('{0}',{1},{2})",
                req.body.wariant_3, id_archiwum, (req.body.prawidlowa_odpowiedz == 3 ? 1 : 0)));
        }
    }
    con.query(format("insert into pytania (id_testu, id_archiwum) values ({0},{1})", req.body.idTestu, id_archiwum));
    
    res.redirect(format('/dodajPytanie/{0}', req.body.idTestu));
}

var usunTest = function (req, res) {
    con.query(format("delete from pytania where id_testu={0}", req.params.idTestu));
    con.query(format("delete from testy where id={0}", req.params.idTestu));
    res.redirect(format('/'));
}

var logowanie = function (req, res) {
    var model = {};

    ejs.renderFile("Views\\logowanie.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
}

var zmianaHasla = function(req, res){
    var model = {};

    ejs.renderFile("Views\\zmianaHasla.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
};

var zmienHaslo = function(req, res){
    var uzytkownicy = con.query(format("SELECT nazwa, imie, nazwisko, haslo, czy_wykladowca, numer_indeksu, kierunek FROM uzytkownicy WHERE nazwa = '{0}'", req.body.nazwa));
    if (uzytkownicy.length > 0) {
        if (uzytkownicy[0].haslo == req.body.haslo) {
            con.query(format("update uzytkownicy set haslo = '{0}'  WHERE nazwa = '{1}'",req.body.noweHaslo, req.body.nazwa));
            res.redirect("/");
        }
    }
};

var czyZalogowany = (req, res, next) => {
    //na potrzeby testów można na sztywno ustawić użytkownika, żeby nie trzeba było się cały czas logować. 
    //Trzeba tylko od komentować linię  poniżej
  //  req.user = { nazwa: 'z', imie: 'z', nazwisko: 'n', haslo: 'test', czy_wykladowca: 0, numer_indeksu: 1234, kierunek: 'Fizyka' }

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
    var nazwaTestu = con.query(format("select nazwa from testy where id = {0}", req.params.idTestu))[0].nazwa;
    var rozwiazania = con.query(format(
        "select r.id,u.imie,u.nazwisko,r.ocena,r.ilosc_zdobytych_pkt, TIMESTAMPDIFF(MINUTE,r.czas_rozpoczecia,r.czas_zakonczenia) as czas from test_studenta t join uzytkownicy  u on t.nazwa_uzytkownika = u.nazwa  left join rozwiazania r on (t.id_testu = r.id_testu and u.nazwa = r.nazwa_uzutkownika)  where t.id_testu=2"
        , req.params.idTestu));
    var model = {
        rozwiazania: rozwiazania,
        nazwaTestu: nazwaTestu

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
        var idPierwszegoPytania = con.query(format("select id from pytania where id_testu={0} order by id", req.params.idTestu))[0].id;
        res.redirect(format('/odpowiedz/{0}', idPierwszegoPytania));
    }
}
var odpowiedz = function (req, res) {

    var pytanie = con.query(format("select a.tresc, p.id, a.ilosc_pkt, p.id_testu from pytania p join archiwum a on p.id_archiwum = a.id where p.id={0}", req.params.idPytania))[0];
    var warianty = con.query(format("select w.id, w.tresc from pytania p join archiwum a on p.id_archiwum = a.id join warianty w on a.id = w.id_archiwum where p.id={0}", req.params.idPytania));
    var rozwiazanie = con.query(format("select id, czas_rozpoczecia from rozwiazania where id_testu = {0} and nazwa_uzutkownika = '{1}'", pytanie.id_testu, req.user.nazwa))[0];
    var czas_na_rozw = con.query(format("select czas_na_rozw_min from testy where id={0}", pytanie.id_testu))[0].czas_na_rozw_min;
    var czas_konca_testu = new Date(rozwiazanie.czas_rozpoczecia).getTime() + czas_na_rozw * 60 * 1000;

    if (warianty.length > 0) {
        //pytanie zamkniete
        var model = {
            pytanie: pytanie,
            warianty: warianty,
            idRozwiazania: rozwiazanie.id,
            czas_konca_testu: czas_konca_testu

        }
        ejs.renderFile("Views\\zamkniete.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
    else {
        //pytanie otwarte
        var model = {
            pytanie: pytanie,
            idRozwiazania: rozwiazanie.id,
            czas_konca_testu: czas_konca_testu
        }
        ejs.renderFile("Views\\opisowe.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    }
}

var zapiszOdpowiedz = function (req, res) {
    //pobranie czasu rozpoczecia testu
    //jeżeli czas rozpoczecia testu+czas rozwiazania testu jest wiekszy niz teraz to zapisz tą odpowiedź, jeżeli nie to test już się skończył

    var czas_na_rozwiazanie = con.query(format("select testy.czas_na_rozw_min, rozwiazania.czas_rozpoczecia from testy "
        + "inner join rozwiazania on rozwiazania.id_testu=testy.id where rozwiazania.id={0}", req.body.idRozwiazania))[0];

    var czy_jest_czas = new Date(czas_na_rozwiazanie.czas_rozpoczecia) > new Date(Date.now() - czas_na_rozwiazanie.czas_na_rozw_min * 60 * 1000);

    if (czy_jest_czas) {

        var zapytanie = format("insert into odpowiedzi (id_rozwiazania, id_pytania, id_wariantu, odpowiedz_otw) values ({0},{1},{2},'{3}')"
            , req.body.idRozwiazania, req.body.idPytania, req.body.wybrana_odp || 'null', req.body.tresc_odpowiedzi || 'null');

        con.query(zapytanie);

    }
    var idTestu = con.query(format("select id_testu from rozwiazania where id = {0}", req.body.idRozwiazania))[0].id_testu;

    var pytaniaBezOdpowiedzi = con.query(format("select pytania.id from pytania where id_testu = {0} and not exists (select 1 from odpowiedzi where odpowiedzi.id_pytania = pytania.id and odpowiedzi.id_rozwiazania = {1})",
        idTestu, req.body.idRozwiazania));

    if (pytaniaBezOdpowiedzi.length > 0 && czy_jest_czas) {
        res.redirect(format('/odpowiedz/{0}', pytaniaBezOdpowiedzi[0].id));
    } else { //koniec testu
        con.query(format("update rozwiazania set czas_zakonczenia = now() where id = {0}", req.body.idRozwiazania));
        res.redirect(format('/'));
    }
}

var sprawdzOpisowe = function (req, res) {
    var odpowiedz = con.query(format(
        "select o.odpowiedz_otw, o.id, o.id_wariantu, a.ilosc_pkt,a.tresc, w.czy_poprawny from odpowiedzi o join pytania p on o.id_pytania = p.id "+
        "join archiwum a on p.id_archiwum = a.id left join warianty w on w.id=o.id_wariantu  where o.id_rozwiazania=1 and o.zdobyte_pkt is null", req.params.id_rozwiazania));
    if (odpowiedz.length > 0) {
        for (var i = 0; i < odpowiedz.length; i++) {
            if (odpowiedz[i].id_wariantu != null) {
                if (odpowiedz[i].czy_poprawny == 1) {
                    con.query(format("update odpowiedzi set zdobyte_pkt={0} where id={1}", odpowiedz[i].ilosc_pkt, odpowiedz[i].id));
                }
                else {
                    con.query(format("update odpowiedzi set zdobyte_pkt=0 where id={0}", odpowiedz[i].id));
                }
            }
            else {
                //jeśli pytanie otwarte
                var model = {
                    odpowiedz: odpowiedz[i],
                    id_rozwiazania: req.params.id_rozwiazania
                }
                ejs.renderFile("Views\\sprawdzOpisowe.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
                return;
            }
        }
        res.redirect(format('/sprawdzOpisowe/{0}', req.params.id_rozwiazania));
    }
    else {
        var id_testu = con.query(format("select id_testu from rozwiazania where id={0}", req.params.id_rozwiazania))[0].id_testu;
        var max_pkt = con.query(format("select sum(a.ilosc_pkt) as suma from pytania p join archiwum a on p.id_archiwum = a.id  where p.id_testu={0}", id_testu))[0].suma;
        var suma_zdobytych_pkt = con.query(format("select sum(zdobyte_pkt) as suma from odpowiedzi where id_rozwiazania={0}", req.params.id_rozwiazania))[0].suma;
        var ocena = "nie zaliczony";
        if (suma_zdobytych_pkt / max_pkt > 0.5) {
            ocena = "zaliczony";
        }
        con.query(format("update rozwiazania set ilosc_zdobytych_pkt={0}, ocena='{1}' where id = {2}", suma_zdobytych_pkt, ocena, req.params.id_rozwiazania));
        res.redirect(format('/wyniki/{0}', id_testu));
        //wroc do wyniki
    }

}
var zapisz_pkt = function (req, res) {
    con.query(format("update odpowiedzi set zdobyte_pkt={0} where id={1}", req.body.zdobytePunkty, req.body.idOdpowiedzi));
    res.redirect(format('/sprawdzOpisowe/{0}', req.body.idRozwiazania));
}

var zobaczWynikiStudent = function (req, res) {
    var zobacz = con.query(format(
    "select r.id, w.id as id_wariantu, o.zdobyte_pkt, a.tresc, a.ilosc_pkt, o.odpowiedz_otw, w.czy_poprawny, w.tresc as wariant_tresc "+
    "from rozwiazania r join pytania p on p.id_testu=r.id_testu join archiwum a on p.id_archiwum = a.id "+
    "left join odpowiedzi o on (o.id_rozwiazania=r.id and o.id_pytania = p.id) "+
    "left join warianty w on w.id=o.id_wariantu where r.id={0} ", req.params.id_rozwiazania));

    var nazwa_testu = con.query(format("select testy.nazwa, rozwiazania.id from rozwiazania inner join testy on rozwiazania.id_testu=testy.id where rozwiazania.id={0} ", req.params.id_rozwiazania))[0].nazwa_testu;
    var model = {
        zobacz: zobacz,
        nazwa_testu: nazwa_testu
    }

    ejs.renderFile("Views\\zobaczWynikiStudent.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
    return;
}

var studenci = function (req, res) {

    var model = {
        studenci: con.query(format("select imie, nazwisko, kierunek, nazwa, numer_indeksu from uzytkownicy where czy_wykladowca = 0")),
    }

    ejs.renderFile("Views\\studenci.ejs", model, function (err, str) { if (err) throw err; res.send(str); })
}

var importujStudentow = function (req, res) {
    if (req.files) {
        var linie = req.files.plik.data.toString('utf8').split('\r');
        if (linie.length > 0) {
            linie.forEach(linia => {
                var kolumny = linia.split(',');
                if (kolumny.length == 6) {
                    con.query(format("insert into uzytkownicy (nazwa,imie,nazwisko,haslo,kierunek,numer_indeksu,czy_wykladowca) values ('{0}','{1}','{2}','{3}','{4}',{5},0)",
                        kolumny[2], kolumny[0], kolumny[1], kolumny[3], kolumny[5], kolumny[4]))
                }
            });
        }
    }
    res.redirect('/studenci');
}

var usunStudenta = function (req, res) {
    con.query(format("delete from odpowiedzi where id_rozwiazania in (select r.id from rozwiazania r where r.nazwa_uzutkownika = '{0}')",req.params.nazwa));
    con.query(format("delete from rozwiazania where nazwa_uzutkownika = '{0}'",req.params.nazwa));
    con.query(format("delete from uzytkownicy where nazwa = '{0}'",req.params.nazwa));
    res.redirect('/studenci');
}

var przypiszTest = function(req, res){
    var model = {
        idTestu: req.params.idTestu,
        studenci: con.query(format("select imie, nazwisko, kierunek, nazwa, numer_indeksu, (select count(1) from test_studenta ts where ts.id_testu = {0} and nazwa_uzytkownika = nazwa) as czy_przypisany from uzytkownicy where not exists (select 1 from rozwiazania r where r.nazwa_uzutkownika = nazwa and r.id_testu = {0})",req.params.idTestu)),
    }
    ejs.renderFile("Views\\przypiszTest.ejs", model, function (err, str) { if (err) throw err; res.send(str); })

}

var przypiszStudentow = function(req, res){
    req.body.studenci.forEach(student => {
    if(student.czy_przypisany){
        if(con.query(format("select 1 from test_studenta where nazwa_uzytkownika ='{0}' and id_testu = {1}",student.nazwa, req.body.idTestu)).length == 0){
            con.query(format("insert into test_studenta (nazwa_uzytkownika,id_testu) values ('{0}',{1})",student.nazwa, req.body.idTestu));
        }
    }else{
        con.query(format("delete from test_studenta where nazwa_uzytkownika = '{0}' and id_testu={1}",student.nazwa, req.body.idTestu));
    }
});
res.redirect("/");
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
app.get('/sprawdzOpisowe/:id_rozwiazania', czyZalogowany, sprawdzOpisowe);
app.post('/zapisz_pkt', czyZalogowany, zapisz_pkt);
app.get('/zobaczWynikiStudent/:id_rozwiazania', czyZalogowany, zobaczWynikiStudent);
app.get('/studenci', czyZalogowany, studenci);
app.post('/importujStudentow', czyZalogowany, importujStudentow)
app.get('/usunStudenta/:nazwa', czyZalogowany, usunStudenta)
app.post('/zmienHaslo', zmienHaslo)
app.get('/zmianaHasla', zmianaHasla)
app.get('/przypiszTest/:idTestu',czyZalogowany, przypiszTest)
app.post('/przypiszStudentow', czyZalogowany, przypiszStudentow)

app.post('/login',
    passport.authenticate('local', { failureRedirect: '/logowanie' }),
    function (req, res) {
        res.redirect('/');
    });

app.listen(8080, () => console.log('Example app listening on port 8080!'));
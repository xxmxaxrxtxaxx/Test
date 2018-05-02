const express = require('express');
var mysql = require('sync-mysql');
var bodyParser = require('body-parser')
var ejs = require('ejs');
var format = require('string-format');

var urlencodedParser = bodyParser.urlencoded({ extended: false})

const app = express();

var con = new mysql({
    host: "localhost",
    user: "testyUser",
    password: "MocneHaslo",
    database: "bazaTestow"
});

var stronaGlowna = function (req, res) {
    var testy = con.query("select nazwa, id from testy");
    var model = {
        tytul :'Strona główna',
        testy :testy
    }
    ejs.renderFile("Views\\home.ejs",model,function(err,str){if(err) throw err; res.send(str);})
}

var dodajTest = function (req, res) {
    ejs.renderFile("Views\\edytuj.ejs",{},function(err,str){if(err) throw err; res.send(str);})
}

var zapiszTest = function(req, res){
    var id= con.query(format("insert into testy (nazwa) values ('{0}')",req.body.nazwa)).insertId;
    res.redirect(format('/dodajPytanie/{0}',id));
}

var dodajPytanie = function(req, res){
    var model = {
        idTestu:req.params.id
    }
    ejs.renderFile("Views\\dodajPytanie.ejs",model,function(err,str){if(err) throw err; res.send(str);})
}

var zapiszPytanie = function(req, res){

    con.query(format("insert into pytania (id_testu, tresc) values ({0},'{1}')",req.body.idTestu, req.body.tresc));
    res.redirect(format('/dodajPytanie/{0}',req.body.idTestu));
}


app.get('/', stronaGlowna);
app.get('/test/:id', (req, res) => res.send('tu bedą wyniki testu nr' + req.params.id));
app.get('/dodajPytanie/:id',dodajPytanie);
app.get('/dodajTest',dodajTest);
app.post('/zapisz', urlencodedParser,zapiszTest);
app.post('/zapiszPytanie', urlencodedParser,zapiszPytanie);


app.listen(8080, () => console.log('Example app listening on port 8080!'));
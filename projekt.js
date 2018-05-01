const express = require('express');
var mysql = require('sync-mysql');
var bodyParser = require('body-parser')
var ejs = require('ejs');

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

var edytujTest = function (req, res) {
    var test = con.query("select nazwa, id from testy where id=" + req.params.id)[0];

    ejs.renderFile("Views\\edytuj.ejs",test,function(err,str){if(err) throw err; res.send(str);})
}

var zapiszTest = function(req, res){
    con.query('update testy set nazwa = \'' + req.body.nazwa + '\' where id = ' + req.body.id);
    res.redirect('/');
}

app.get('/', stronaGlowna);
app.get('/test/:id', (req, res) => res.send('tu bedą wyniki testu nr' + req.params.id));
app.get('/edytuj/:id',edytujTest);
app.post('/zapisz', urlencodedParser,zapiszTest);

app.listen(8080, () => console.log('Example app listening on port 8080!'));
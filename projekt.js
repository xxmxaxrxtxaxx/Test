const express = require('express');
var mysql = require('sync-mysql');
var bodyParser = require('body-parser')

var urlencodedParser = bodyParser.urlencoded({ extended: false})

const app = express();

var con = new mysql({
    host: "localhost",
    user: "testyUser",
    password: "MocneHaslo",
    database: "bazaTestow"
});

var szablon = function (body) {
    var text = ''
    text += '<html><head>'
    text += '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">'
    text += '</head><body>';
    text += '<div class="navbar bg-dark"><a class="navbar-brand" href="#">Projekt Testy</a></div>'
    text += '<div class="row">'
    text += body;
    text += '</div>'
    text += '<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>'
    text += '<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>'
    text += '<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>'
    text += '</body></html>';
    return text;
};

var stronaGlowna = function () {
    var testy = con.query("select nazwa, id from testy");
    var html = '';
    html += '<table class="table table-striped"><tr><th>Nazwa</th><th>Akcje</th></tr>'
    for (var i = 0; i < testy.length; i++) {
        html += '<tr><td>' + testy[i].nazwa + '</td>'
        html += '<td><a href="test/' + testy[i].id + '">Wyniki</a><a href="edytuj/' + testy[i].id + '">Edytuj</a></td>'
        html += '</tr>';
    }
    html += '</table>'
    return html;
}

var edytujTest = function (id) {
    var test = con.query("select nazwa, id from testy where id=" + id)[0];

    var html = '<form class="form form-horizontal" method="POST" action="/zapisz">';
    html += '<input class="form-control" type="hidden" name="id" value="' + test.id + '"/>';
    html += '<input class="form-control" type="text" name="nazwa" value="' + test.nazwa + '"/>';
    html += '<input class="button button-primary" type="submit"/>';
    html += '</form>';
    return html;
}


app.get('/', (req, res) => res.send(szablon(stronaGlowna())));
app.get('/test/:id', (req, res) => res.send('tu bedą wyniki testu nr' + req.params.id));
app.get('/edytuj/:id', (req, res) => res.send(szablon(edytujTest(req.params.id))));
app.post('/zapisz', urlencodedParser,(req, res) => {

    con.query('update testy set nazwa = \'' + req.body.nazwa + '\' where id = ' + req.body.id);
    res.redirect('/');
})

app.listen(8080, () => console.log('Example app listening on port 8080!'));
(function() {
  var app, assets, coffeekup, express, _;

  assets = require('connect-assets');

  express = require('express');

  coffeekup = require('coffeekup');

  _ = require('underscore');

  app = express.createServer();

  app.use(require('connect-assets')());

  app.set('view engine', 'coffee');

  app.register('.coffee', coffeekup.adapters.express);

  app.get('/', function(req, res) {
    return res.render('index');
  });

  app.listen(3000);

  console.log("Started web server on port 3000: http://localhost:3000/");

}).call(this);

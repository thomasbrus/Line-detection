(function() {
  var app, assets, express, _;

  assets = require('connect-assets');

  express = require('express');

  _ = require('underscore');

  app = express.createServer();

  app.get('/', function(req, res) {
    return res.send('Hello World');
  });

  app.listen(3000);

}).call(this);

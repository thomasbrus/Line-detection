assets  = require 'connect-assets'
express = require 'express'
_ = require 'underscore'

# Do some express stuff (or maybe use Zappa.coffee?)

app = express.createServer();

app.get '/', (req, res) ->
  res.send 'Hello World'
  
app.listen 3000
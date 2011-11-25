assets      = require 'connect-assets'
express     = require 'express'
coffeekup   = require 'coffeekup'
_           = require 'underscore'

app = express.createServer()

# Middleware
app.use express.logger('dev')
app.use require('connect-assets')()

# Settings

#app.set 'view engine', 'coffee'
#app.register '.coffee', coffeekup.adapters.express

# Routes
app.get '/', (req, res) ->
  res.render 'index.jade'

# Listen on port 3000
app.listen 3000
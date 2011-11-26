express       = require 'express'
coffeekup     = require 'coffeekup'

server = express.createServer()

# Middleware
server.use express.logger('dev')
server.use require('connect-assets')(buildDir: '.builtAssets')

# Settings
server.set 'view engine', 'coffee'
server.register '.coffee', coffeekup.adapters.express

# Routes
server.get '/', (req, res) ->
  res.render 'index'

# Listen on port 3000
server.listen 3000
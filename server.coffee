express       = require 'express'
coffeekup     = require 'coffeekup'

server = express.createServer()

# Middleware
server.use express.logger('dev')
server.use require('connect-assets')(buildDir: '.builtAssets')

# Static image serving
server.use(express.static(__dirname + '/public'));

# Settings
server.set 'view engine', 'coffee'
server.register '.coffee', coffeekup.adapters.express

# Routes
server.get '/', (req, res) ->
  res.render 'index'

# Listen on port 3000
server.listen (process.env.PORT || 3000)

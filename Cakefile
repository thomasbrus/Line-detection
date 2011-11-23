fs            = require 'fs'
{print}       = require 'util'
{spawn}       = require 'child_process'

coffee = null

stream = (command, options, callback) ->
  sub = spawn command, options
  sub.stdout.on 'data', (data) -> print data.toString()
  sub.stderr.on 'data', (data) -> print data.toString()
  sub.on 'exit', (status) -> callback?() if status is 0
  sub

start = ->
  coffee?.kill()
  console.log "Started web server on port 3000 at #{(new Date()).toTimeString()}"
  coffee = stream 'coffee', ['app.coffee']

task 'start', 'Run server', ->
  process.env["NODE_ENV"] = 'production'
  start()

task 'dev', 'Run server and restart when source is modified', ->
  process.env["NODE_ENV"] = 'development'
  start()
  fs.watchFile 'app.coffee', (curr, prev) ->
    start() if curr.mtime > prev.mtime
fs              = require 'fs'
{print}         = require 'util'
{spawn, exec}   = require 'child_process'

coffee = vows = null

stream = (command, options, callback) ->
  subprocess = spawn command, options
  subprocess.stdout.on 'data', (data) -> process.stdout.write data
  subprocess.stderr.on 'data', (data) -> process.stderr.write data
  subprocess.on 'exit', (status) -> callback?() if status is 0
  subprocess

start = ->
  coffee?.kill()
  console.log "Started web server on port 3000 at #{(new Date()).toTimeString()}"
  coffee = stream 'coffee', ['server.coffee']
  
test = (watch) ->
  vows?.kill()
  options = ['--spec']
  options = options.concat('--watch') if watch?
  
  fs.readdir 'test', (err, files) ->
    for file in files
      options = options.concat('test/' + file) if /.+\_test\.coffee/.test file
    vows = stream 'vows', options

task 'start', 'Run server', ->
  process.env.NODE_ENV = 'production'
  start()

task 'dev', 'Run server and restart when source is modified', ->
  process.env.NODE_ENV = 'development'
  start()
  fs.watchFile 'server.coffee', (curr, prev) ->
    start() if curr.mtime > prev.mtime
    
task 'test', 'Run all tests', (options) ->
  test()
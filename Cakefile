fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'
{watchTree}   = require 'watch-tree'

node = null

stream = (command, options, callback) ->
  sub = spawn command, options
  sub.stdout.on 'data', (data) -> print data.toString()
  sub.stderr.on 'data', (data) -> print data.toString()
  sub.on 'exit', (status) -> callback?() if status is 0
  sub

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false
  options = ['--compile', '--output', 'lib', 'src']
  options.unshift '--watch' if watch
  coffee = stream 'coffee', options, callback

start = ->
  build ->
    node?.kill()
    options = ['lib/server.js']
    node = stream 'node', options

task 'build', 'Compile CoffeeScript source files', ->
  build()

task 'start', 'Run server', ->
  process.env["NODE_ENV"] = "production"
  start()

task 'dev', 'Run server and recompile when source is modified', ->
  process.env["NODE_ENV"] = "development"
  start()
  watcher = watchTree 'src', 'sample-rate': 5
  watcher.on 'fileModified', start
  watcher.on 'fileCreated', start
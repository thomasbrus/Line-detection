doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title @title or "Line Detection Demonstration"
    meta(name: 'description', content: @description) if @description?

    link rel: 'stylesheet', href: '/css/style.css'
    script src: '/js/client.js'

  body ->
    header ->
      h1 @title
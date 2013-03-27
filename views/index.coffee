header ->
  h1 'Line Detection Experiment'
  section '.description', ->
    p 'Op deze pagina kunt u onze poging tot een lijn-
    detectie algoritme uittesten. Het is gebaseerd op de Hough Transform
    en de paper van M. Fokkinga.'

    p '.links', ->
      a '.link', href: 'https://github.com/thomasbrus/line-detection', ->
        'https://github.com/thomasbrus/line-detection'
      span -> '—'
      a '.link', href: 'http://t.coenraad.at/', ->
        'Twan Coenraad'
      span -> '&'
      a '.link', href: 'http://thomasbrus.nl/', ->
        'Thomas Brus'
      
section '#region', ->
  canvas id: 'canvas', width: '300', height: '540'
  div class: 'left'
  div class: 'middle'
  div class: 'right'
  h3 '#placeholder', 'Voeg een punt toe om te beginnen.'

a '#eraser', href: '/'
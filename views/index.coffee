header ->
  h1 'Line Detection Experiment'
  section '.description', ->
    p 'Test op deze pagina onze nederige poging tot een lijn-
    detectie algoritme uit. Het is gebaseerd op de Hough Transform
    en de beschrijving daarvan in de paper van M. Fokkinga.'

    p ->
      a '.link', href: 'https://github.com/thomasbrus/line-detection', ->
        'https://github.com/thomasbrus/line-detection'
      '.'
      
section '#region', ->
  canvas id: 'canvas', width: '300', height: '540'
  div class: 'left'
  div class: 'middle'
  div class: 'right'
  h3 '#placeholder', 'Voeg een punt toe om te beginnen.'

a '#eraser', href: '/'
$ ->

    # CONSTANTS




    canvasFront = document.getElementById 'front'
    ctxFront = canvasFront.getContext '2d'

    canvasBack = document.getElementById 'front'
    ctxBack = canvasBack.getContext '2d'

    # initialize size
    canvasBack.width = document.width
    canvasBack.height = document.height

    canvasFront.width = document.width
    canvasFront.height = document.height

    game = new Game ctxFront, ctxBack, document.width, document.height
    game.init()
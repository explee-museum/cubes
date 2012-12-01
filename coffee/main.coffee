$ ->
    window.onload = () ->
    # img = new Image()
    # img.src = 'img/spriteGlobal.png'
    # img.onload = () ->
        #BUILDING TYPES
        canvasFront = document.getElementById 'front'
        ctxFront = canvasFront.getContext '2d'

        canvasBack = document.getElementById 'back'
        ctxBack = canvasBack.getContext '2d'

        canvasDebug = document.getElementById 'frontDebug'
        ctxDebug = canvasBack.getContext '2d'

        # initialize size
        canvasBack.width = document.width
        canvasBack.height = document.height

        canvasFront.width = document.width
        canvasFront.height = document.height

        canvasDebug.width = document.width
        canvasDebug.height = document.height

        game = new Game ctxFront, ctxBack, document.width, document.height
        game.init()

        # webcam = document.getElementById 'webcam'
        # frontVideoCanvas = document.getElementById 'frontVideo'
        # backVideoCanvas = document.getElementById 'backVideo'

        # window.video = new Video webcam, frontVideoCanvas, backVideoCanvas
        # video.init()
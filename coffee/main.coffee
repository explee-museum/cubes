$ ->
    window.onload = () ->
    # img = new Image()
    # img.src = 'img/spriteGlobal.png'
    # img.onload = () ->
        # CONSTANTS
        $('img').each (i, elem) ->
            $(elem).hide()

        #BUILDING TYPES
        canvasFront = document.getElementById 'front'
        ctxFront = canvasFront.getContext '2d'

        canvasBack = document.getElementById 'back'
        ctxBack = canvasBack.getContext '2d'
        window.ctxBack = ctxBack

        canvasDebug = document.getElementById 'frontDebug'
        ctxDebug = canvasBack.getContext '2d'

        canvasWeather = document.getElementById 'weather'
        ctxWeather = canvasWeather.getContext '2d'

        # initialize size
        canvasBack.width = document.width
        canvasBack.height = document.height

        canvasFront.width = document.width
        canvasFront.height = document.height

        canvasDebug.width = document.width
        canvasDebug.height = document.height

        canvasWeather.width = document.width
        canvasWeather.height = document.height

        game = new Game ctxFront, ctxBack, ctxWeather, document.width, document.height
        game.init()        
        window.game = game

        # Video
        webcam = document.getElementById 'webcam'
        window.webcam = webcam

        frontVideoCanvas = document.getElementById 'frontVideo'
        frontVideoCtx = frontVideoCanvas.getContext '2d'
        window.frontVideoCanvas = frontVideoCanvas

        backVideoCanvas = document.getElementById 'backVideo'
        backVideoCtx = backVideoCanvas.getContext '2d'
        window.backVideoCtx = backVideoCtx

        debugVideoCanvas = document.getElementById 'frontVideoDebug'
        debugVideoCtx = debugVideoCanvas.getContext '2d'

        debugCanvas = document.getElementById 'frontDebug'
        debugCtx = debugCanvas.getContext '2d'

        cv = new Cv backVideoCanvas
        window.cv = cv

        blobDetector = new BlobDetector(Cv, backVideoCanvas);
        window.blobDetector = blobDetector

        video = new Video webcam, frontVideoCanvas, frontVideoCtx, backVideoCanvas, backVideoCtx, debugCanvas, debugCtx, game        
        window.video = video
        

        # Audio
        document.getElementById('speech_result').onwebkitspeechchange = (val) ->
            if game.resources[game.MANA] >= 10
                game.resources[game.MANA] -= 10

                switch val.target.value
                    when 'rain', 'brain', 'wayne'
                        game.weather = game.WEATHER_RAIN
                    when 'warm', 'test'
                        game.weather = game.WEATHER_WARM
                    when 'snow', 'no', 'note', 'stove'
                        game.weather = game.WEATHER_SNOW
                    when 'sun'
                        game.weather = game.WEATHER_SUN
                    else
                        game.resources[game.MANA] += 10
            
                game.drawWeather ctxWeather

        $('canvas').click (event) ->
            console.log event.pageX
            console.log event.pageY

        document.getElementById('technos').addEventListener('DOMSubtreeModified', () ->
            $('#technos').show().fadeOut 3000
        ,false)

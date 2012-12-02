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

        # micVisible = false
        # $('#mic').click () ->
        #     if not micVisible
        #         $(this).animate({
        #             'margin-right': -20
        #             }, 300)
        #         micVisible = true

        document.getElementById('speech_result').onwebkitspeechchange = (val) ->
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
                    game.weather = game.WEATHER_SUN
            
            game.drawWeather ctxWeather

        $('canvas').click (event) ->
            console.log event.pageX
            console.log event.pageY

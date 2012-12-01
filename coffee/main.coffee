$ ->
    window.onload = () ->
    # img = new Image()
    # img.src = 'img/spriteGlobal.png'
    # img.onload = () ->
        # CONSTANTS

        #BUILDING TYPES
        
        canvasFront = document.getElementById 'front'
        ctxFront = canvasFront.getContext '2d'

        canvasBack = document.getElementById 'back'
        ctxBack = canvasBack.getContext '2d'

        canvasWeather = document.getElementById 'weather'
        ctxWeather = canvasWeather.getContext '2d'

        # initialize size
        canvasBack.width = document.width
        canvasBack.height = document.height

        canvasFront.width = document.width
        canvasFront.height = document.height

        canvasWeather.width = document.width
        canvasWeather.height = document.height

        game = new Game ctxFront, ctxBack, document.width, document.height
        game.init()

        micVisible = false
        $('#mic').click () ->
            if not micVisible
                $(this).animate({
                    'margin-right': -20
                    }, 300)
                micVisible = true

        document.getElementById('speech_result').onwebkitspeechchange = (val) ->
            switch val.target.value
                when 'rain'
                    game.weather = game.WEATHER_RAIN
                when 'warm'
                    game.weather = game.WEATHER_WARM
                when 'snow'
                    game.weather = game.WEATHER_SNOW
                when 'sun'
                    game.weather = game.WEATHER_SUN
                else
                    game.weather = game.WEATHER_SUN
            
            game.drawWeather ctxWeather

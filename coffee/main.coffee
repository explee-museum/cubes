window.onload = () ->

    # Once images are loaded, hide the loading
    $('#loading').hide()

    # Init the diferent canvas & their context
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
    canvasBack.width = document.body.clientWidth
    canvasBack.height = document.body.clientHeight

    canvasFront.width = document.body.clientWidth
    canvasFront.height = document.body.clientHeight

    canvasDebug.width = document.body.clientWidth
    canvasDebug.height = document.body.clientHeight

    canvasWeather.width = document.body.clientWidth
    canvasWeather.height = document.body.clientHeight

    game = new Game ctxFront, ctxBack, ctxWeather, document.body.clientWidth, document.body.clientHeight
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

    grammar = '#JSGF V1.0; grammar weather; public <weather> = rain | warm | snow | sun ;'

    recognition = null
    if window.webkitSpeechRecognition?
        recognition = new webkitSpeechRecognition()
        speechRecognitionList = new webkitSpeechGrammarList()
    else if window.SpeechRecognition?
        recognition = new SpeechRecognition()
        speechRecognitionList = new SpeechGrammarList()
    else
        console.log('No mic.')

    if recognition? && recognition != null
        speechRecognitionList.addFromString(grammar, 1)
        recognition.grammars = speechRecognitionList

        recognition.lang = 'en-US'
        recognition.interimResults = false
        recognition.maxAlternatives = 1

        recognition.onerror = (e) ->
            console.log('Speech recognition error detected: ' + e.error);

        recognition.onresult = (event) ->
            weather = event.results[0][0].transcript
            if game.resources[game.MANA] >= 10
                game.resources[game.MANA] -= 10

                switch weather
                    when 'rain'
                        game.weather = game.WEATHER_RAIN
                    when 'warm'
                        game.weather = game.WEATHER_WARM
                    when 'snow'
                        game.weather = game.WEATHER_SNOW
                    when 'sun'
                        game.weather = game.WEATHER_SUN
                    else
                        game.resources[game.MANA] += 10

                game.drawWeather ctxWeather

    # Audio
    document.getElementById('speech_result').onclick = () ->
        recognition.start()

    document.getElementById('technos').addEventListener('DOMSubtreeModified', () ->
        $('#technos').show().fadeOut 3000
    ,false)

    document.getElementById('count').addEventListener('DOMSubtreeModified', () ->
        $('#score').show().fadeIn 400

    ,false)

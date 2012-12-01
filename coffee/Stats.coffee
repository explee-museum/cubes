class Stats
    constructor: (@video) ->    
        @decodedFrames = 0
        @droppedFrames = 0
        @decodedFPS = 0
        @droppedFPS = 0
        @startTime = 0

        @video.addEventListener "playing", (event) =>
            @startTime = new Date().getTime()
            update()

        @video.addEventListener "error", () -> 
           @endTest(false)
        , false

        @video.addEventListener "ended", () -> 
            @endTest(true)
        , false

    calculate: (logDiv) ->
        if @video.readyState <= HTMLMediaElement.HAVE_CURRENT_DATA || @video.paused || @video.ended
            return

        currentTime = new Date().getTime()
        deltaTime = (currentTime - @startTime) / 1000

        if deltaTime > 5
            @startTime = currentTime

            # Calculate decoded frames per sec.
            fps = (video.webkitDecodedFrameCount - @decodedFrames) / deltaTime
            @decodedFrames = video.webkitDecodedFrameCount
            @decodedFPS = fps

            # Calculate dropped frames per sec.
            fps = (video.webkitDroppedFrameCount - @droppedFrames) / deltaTime
            @droppedFrames = video.webkitDroppedFrameCount
            @droppedFPS = fps

            logDiv.innerHTML = "Decoded frames: " + @decodedFrames + " Avg: " + @decodedFPS + " fps.<br>" + "Dropped frames: " + @droppedFrames + " Avg: " + @droppedFPS + " fps.<br>"

    endTest: (successFlag) -> 
        # Notify PyAuto that we've completed the test run.
        if window.domAutomationController
            window.domAutomationController.send(successFlag)

    startTest: (url) ->
        @video.src = url
        @video.play()

if typeof module isnt 'undefined' && module.exports
    exports.Stats = Stats
else 
    window.Stats = Stats
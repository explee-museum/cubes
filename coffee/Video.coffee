class Video
    constructor: (@webcam, @canvasVideoFront, @ctxVideoFront, @canvasVideoBack, @ctxVideoBack, @canvasVideoDebug, @ctxVideoDebug, @game) ->
        @cv = new Cv @canvasVideoBack
        @blobDetector = new BlobDetector @cv, @canvasVideoBack

        @active = false
        @tilex = @tiley = @savedTilex = @savedTiley = null
        @fakeDuration = 0

        @lastFrame = @frame = null
        @sizeTile = 50

    update: () ->        
        # Plug the video element to canvas
        @ctxVideoBack.drawImage @webcam, 0, 0, @webcam.width, @webcam.height

        result = @blobDetector.detect()
        sizedBounds = @cv.convertBounds result.bounds, @canvasVideoFront, @canvasVideoDebug
        
        @frame = @ctxVideoBack.getImageData(0, 0, @canvasVideoBack.width, @canvasVideoBack.height)
        if @lastFrame is null then @lastFrame = @frame
        isOnZone = @blobDetector.blend(@lastFrame, @frame, @ctxVideoFront)
        if (isOnZone and @active is false) then @active = true
        @lastFrame = @frame
        resetDuration = 0
        @canvasVideoDebug.width = @canvasVideoDebug.width
        if @active          
            
            @tilex = Math.floor((@canvasVideoDebug.width  - sizedBounds.x)/@sizeTile)
            @tiley = Math.floor(sizedBounds.y/@sizeTile)
            if(@tilex is @savedTilex && @tiley is @savedTiley)
                @fakeDuration++
            else
                @fakeDuration = 0
            @savedTilex = @tilex
            @savedTiley = @tiley

            if @fakeDuration > 25
                if @game.resources[@game.MANA] > 6
                    @game.resources[@game.MANA] -= 7
                    if result.type isnt @game.map.tiles[@tilex][@tiley].type
                        buildingIndex = @game.buildings.indexOf(@game.map.tiles[@tilex][@tiley].building)                    
                        @game.buildings.splice(buildingIndex, 1)

                    @game.map.addMapElement result.type, @tilex, @tiley, @ctxVideoBack
                @active = false
                @savedTilex = null
                @fakeDuration = 0

            if resetDuration > 300
                @fakeDuration = @resetDuration = 0

            resetDuration++

            @ctxVideoDebug.fillStyle = 'white'
            @ctxVideoDebug.globalAlpha =  0.5
            @ctxVideoDebug.fillRect(@sizeTile * @tilex, @sizeTile * @tiley, @sizeTile, @sizeTile)
                
window.Video = Video
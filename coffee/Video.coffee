class Video
    constructor: (@webcam, @canvasFront, @canvasBack) ->
        @ctxFront = @canvasFront.getContext '2d'
        @ctxBack = @canvasBack.getContext '2d'

        cv = new Cv @canvasBack
        @blobDetector = new BlobDetector cv, @canvasBack
        @Stats = new Stats @webcam

    # init: () ->
    #     window.URL = window.URL || window.webkitURL
    #     navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;

    #     @requestAnimFrame = () ->
    #         return  window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || ( callback ) ->
    #                 window.setTimeout canvasllback, 1000 / 60

    #     mousex = mousey = 0
    #     # offset = $(frontVideoCanvas).offset()
    #     # colorDiv = document.getElementById('color')
    #     # $(frontVideoCanvas).mousemove () ->
    #     #     mousex = Math.floor(e.pageX - offset.left)
    #     #     mousey = Math.floor(e.pageY - offset.top)
    #     #     colorStr = BlobDetector.getPixelColor(backCtx, mousex, mousey)
    #     #     colorDiv.innerHTML = colorStr

    #     @log = document.getElementById 'log'
    #     @weight = [1/9, 1/9, 1/9, 1/9, 1/9, 1/9, 1/9, 1/9, 1/9]

    #     @Stats = new Stats @webcam
    #     if navigator.getUserMedia
    #         navigator.getUserMedia {audio: false, video: true}, (stream) =>
    #             @Stats.startTest window.URL.createObjectURL(stream)
    #             @update()
    #         , () ->
    #             console.log('you fail');


    update: () ->        
        @Stats.calculate @log
        @requestAnimFrame @update

        # webcam to canvas link
        @ctxBack.drawImage @webcam, 0, 0, @webcam.width, @webcam.height
        pixels = @ctxBack.getImageData 0, 0, @canvasBack.width, @canvasBack.height
        console.log 'pixels', pixels.data

        # some freaky functions
        # pixels = @ctxBack.getImageData 0, 0, @canvasBack.width, @canvasBack.height
        # frame = Cv.convolute(pixels, weight, false);
        # @ctxBack.putImageData(frame, 0, 0);

        # Debugging purpose : showing the webcam
        frame = @ctxBack.getImageData 0, 0, @canvasFront.width, @canvasFront.height
        @ctxFront.putImageData frame, 0, 0

        # Draw result       
        # rBounds = BlobDetector.detect(35, 50);
        bBounds = @blobDetector.detect 185, 210, @ctxFront

        # gBounds = BlobDetector.detect(90, 105);         
        # ctx.fillStyle = 'red';
        # ctx.fillRect(Math.floor(rBounds.x),Math.floor(rBounds.y), 5, 5);
        @ctxFront.fillStyle = 'blue'
        @ctxFront.fillRect Math.floor(bBounds.x), Math.floor(bBounds.y), 5, 5
        # ctx.strokeStyle = 'green';
        # ctx.strokeRect(gBounds.x, gBounds.y, 50, 50);

if typeof module isnt 'undefined' && module.exports
    exports.Video = Video
else 
    window.Video = Video
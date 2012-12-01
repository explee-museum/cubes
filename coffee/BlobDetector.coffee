class BlobDetector
    constructor: (@canvas, @filters) ->
        @ctx = @canvas.getContext '2d'

    process: () ->
        imageData = @ctx.getImageData 0, 0, @canvas.width, @canvas.height
        r1 = @getDiffImage imageData
        r2 = @getBlocks r1
        r3 = drawBlobs imageData
        return [r1, r2, r3]

    getDiffImage: (imageData) ->
        pt = 
            x: 0
            y: 0
        originalImageData = imageData

        @ctx.translate 2, 0
        r = @ctx.getImageData 0, 0, @canvas.width, @canvas.height 
        r.data = @filters.filter(filter.blend, r, originalImageData, rect, 2, 'difference')
        tmpRect =
            x: 2
            y: 0 
            w: 2
            h: imageData.height
        r.data = @copyPixels originalImageData, tmpRect, pt

        @ctx.translate -2, 2
        r2 = @ctx.getImageData 0, 0, @canvas.width, @canvas.height 
        r2.data = @filters.filter(filter.blend, r2, originalImageData, rect, 2, 'difference')
        tmpRect =
            x: 0,
            y: 2, 
            w: imageData.width,
            h: 2
        r2.data = @copyPixels originalImageData, tmpRect, pt

        rect =
            x: 0,
            y: 0, 
            w: imageData.width, 
            h: imageData.height
        pt = {0, 0}
        # Not sure about that
        r.data = @filters.filter(filter.blend, r, r2, rect, 2, 'add')        

        weight = [
            0.1,0.1,0.1,
            0.1,0.1,0.1,
            0.1,0.1,0.1
        ]
        r = @filters.convolution r, weight, 0

        # We discover what is interesting
        r = @filters.threshold r, "<", 10, 0
        # We remove everything else
        r = @filters.threshold r, "!=", 233, 255 
    
        return r

    getBlocks: (imageData) ->
        blocks = []
        r = @ctx.getImageData 0, 0, @canvas.width, @canvas.height

        while true
            i++
            if i>1000 then break
            
        rect1 = @getColorBoundsRect(r, 'ffffff','ff00ff')
        if rect1? then return

        x = rect1.x
        for y in [rect1.y..rect1.y + rect1.height]
            if r.data[(y * r.width * 4) + x * 4] is 255 and r.data[(y * r.width * 4) + x * 4 + 1] is 255 and r.data[(y * r.width * 4) + x * 4 + 2] is 255 
                ctx.fillStyle = "rgb(127,127,127)"
                ctx.fillRect x, y, 1, 1
                rect2 = @getColorBoundsRect(r, 'ffffff','ff00ff')
                size = rect2.width * rect2.height
                if size>300
                    o =
                        size: size
                        rect: rect2
                        bmpd: @ctx.getImageData o.rect.width,o.rect.height
                    r.imageData = o.bmpd.data r, o.rect, 
                    blocks.push o
        
        ctx.fillStyle = "00ff00"
        ctx.fillRect x, y, 1, 1

        for i in [0..blocks.length-1]
            @ctx.strokeStyle = "00ff00"
            g.drawRect(blocks[i].rect.x, blocks[i].rect.y, blocks[i].rect.width, blocks[i].rect.height)

        r.draw(sp)
        return r

    drawBlobs: (imageData) ->
        r = @ctx.getImageData 0, 0, @canvas.width, @canvas.height                

        for i in [0..blocks.length-1]
            pts = []
            b = blocks[i]
            for y in [0..b.rect.height-1]
                for x in [0..b.rect.width-1]
                    if b.bmpd.getPixel(x,y) is 0xff00ff
                        pts.push({x,y})
                        break
            for y in [b.rect.height-1..0] by -5
                for x in [b.rect.width-1..0]
                    if b.bmpd.getPixel(x,y) is 0xff00ff
                        pts.push({x,y})
                        break

        @ctx.save()
        @ctx.fillStyle = "ff0000"
        @ctx.lineWidth = 0.2
        @ctx.strokeStyle = "ff0000"
        @ctx.beginPath()        
        for j in [0..pts.length-1]
            if j is 0
                # mid1 = Point.interpolate(pts[j], pts[(j + 1) % pts.length], 0.5)
                @ctx.moveTo b.rect.x + mid1.x, b.rect.y + mid1.y
            # mid2 = Point.interpolate(pts[(j + 2) % pts.length], pts[(j + 1) % pts.length], 0.5)
            @ctx.quadraticCurveTo(b.rect.x + pts[(j + 1) % pts.length].x, b.rect.y + pts[(j + 1) % pts.length].y, b.rect.x + mid2.x, b.rect.y + mid2.y)
        
        @ctx.fill()
        @ctx.restore()

        return r

    getColorBoundsRect: (imageData, minThreshold, maxThreshold) ->
        xMin = yMin = xMax = yMax = 0
        @ctx.save()
        @ctx.strokeStyle = "ff0000"
        @ctx.strokeRect xMin, yMin, xMax - xMin, yMax - yMin
        @ctx.restore()

    getPixelColor: (imageData, x, y) ->
        p = [
            (y * imageData.width * 4) + x * 4,
            (y * imageData.width * 4) + x * 4 + 1,
            (y * imageData.width * 4) + x * 4 + 2
        ]

        return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);

    blend: () ->
        width = @canvas.width;
        height = @canvas.height;                
        sourceData = @ctx.getImageData(0, 0, width, height);

        if typeof lastImageData is 'undefined' 
            lastImageData = @ctx.getImageData 0, 0, width, height

        blendedData = @ctx.createImageData(width, height);

        @differenceAccuracy blendedData.data, sourceData.data, lastImageData.data

        ctxblended.putImageData(blendedData, 0, 0); 
        lastImageData = sourceData;

    copyPixels: (ctx, srcRect, destPt) ->
        ctx.putImageData srcRect, destPt.x, destPt.y


if typeof module isnt 'undefined' && module.exports
    exports.BlobDetector = BlobDetector
else 
    window.BlobDetector = BlobDetector
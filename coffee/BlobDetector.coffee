class BlobDetector
    constructor: (@cv, @canvas) ->
        @ctx = @canvas.getContext '2d'

    process: () ->
        imageData = @ctx.getImageData 0, 0, @canvas.width, @canvas.height
        r1 = @getDiffImage imageData
        r2 = @getBlocks r1
        r3 = @drawBlobs imageData
        return [r1, r2, r3]

    getDiffImage: (imageData) ->
        # Copy the image
        originalImageData = imageData

        # we translate the image to the rigth
        @ctx.translate 2, 0
        # we grab the image
        tmp = @ctx.getImageData 0, 0, @canvas.width, @canvas.height 
        # We blend it with its original form with a diff filter
        blend1 = @cv.blend tmp, originalImageData, 'difference'
        # We copy back the 2 columns from the original image to the blend one
        destPt = #destination pixel for copied pixels
            x: 0
            y: 0        
        srcRect = # src pixels to cpy
            x: 2
            y: 0 
            w: 2
            h: imageData.height
        @cv.copyPixels originalImageData, srcRect, blend1, destPt

        # We do that again with a moov downwards
        @ctx.translate -2, 2
        tmp = @ctx.getImageData 0, 0, @canvas.width, @canvas.height 
        blend2 = @cv.blend tmp, originalImageData, 'difference'
        srcRect =
            x: 0,
            y: 2, 
            w: imageData.width,
            h: 2
        @cv.copyPixels originalImageData, srcRect, blend2, destPt

        #we blend the two result with an add filter
        rect =
            x: 0,
            y: 0, 
            w: 2, 
            h: imageData.height
        # Not sure about that
        finalBlend = @cv.blend blend1, blend2, 'add'

        # We blur it with a convolution matrix (remove noise)
        weight = [
            0.1,0.1,0.1,
            0.1,0.1,0.1,
            0.1,0.1,0.1
        ]
        finalImg = @cv.convolute finalBlend, weight, true 

        # threshold to get what we want
        finalImg = @cv.threshold finalImg, "<", 10, 0
        # We remove everything else
        finalImg = @cv.threshold finalImg, "!=", 233, 255 
    
        return finalImg

    getBlocks: (imageData) ->
        @blocks = []
        r = @ctx.getImageData 0, 0, @canvas.width, @canvas.height
            
        rect1 = @getColorBoundsRect(r, 'ffffff','ff00ff')
        if not rect1? then return

        x = rect1.x
        for y in [rect1.y..rect1.y + rect1.height-1]
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
                    @blocks.push o
        
        ctx.fillStyle = "00ff00"
        ctx.fillRect x, y, 1, 1

        for i in [0..@blocks.length-1]
            @ctx.strokeStyle = "00ff00"
            g.drawRect(@blocks[i].rect.x, @blocks[i].rect.y, @blocks[i].rect.width, @blocks[i].rect.height)

        r.draw(sp)
        return r

    drawBlobs: (imageData) ->
        r = @ctx.getImageData 0, 0, @canvas.width, @canvas.height                

        for i in [0..@blocks.length-1]
            pts = []
            b = @blocks[i]
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

    getPixelColor: (x, y) ->
        p = @ctx.getImageData(x, y, 1, 1).data

        hsl = @cv.rgbToHsl p[0], p[1], p[2]
        str = 'h:' + hsl[0] + ' s:' + hsl[1] + ' l:' + hsl[2]
        
        return str
        # return @cv.rgbToHex(p[0], p[1], p[2]);

    blend: (lastImageData, sourceData, ctx, ctx2) ->
        width = @canvas.width
        height = @canvas.height                
        blendedData = @ctx.createImageData width, height

        @differenceAccuracy blendedData.data, sourceData.data, lastImageData.data

        ctx.putImageData blendedData, 0, 0 if ctx?

        zone = ctx.getImageData(0, 0, 50, 50)
        ctx2.putImageData zone, 0, 0 if ctx2?
        average = 0  
        len = zone.data.length-4  
        for i in [0..len] by 4
            average += (zone.data[i] + zone.data[i+1] + zone.data[i+2]) / 3;            
        
        average = Math.round(average / (zone.data.length * 0.25))
        
        if average > 150
            return true
        else
            return false

    differenceAccuracy: (target, data1, data2) ->
        if data1.length isnt data2.length then return null

        len = data1.length - 4
        for i in[0..len] by 4
            average1 = (data1[i] + data1[i+1] + data1[i+2]) / 3
            average2 = (data2[i] + data2[i+1] + data2[i+2]) / 3
            diff = @threshold(@fastAbs(average1 - average2));
            target[i] = diff * 255
            target[i+1] = diff * 255
            target[i+2] = diff * 255
            target[i+3] = 255

    fastAbs: (value) ->                
        return (value ^ (value >> 31)) - (value >> 31)

    threshold: (value) ->
        return (value > 0x15) ? 0xFF : 0

    copyPixels: (ctx, srcRect, destPt) ->
        ctx.putImageData srcRect, destPt.x, destPt.y

    detect: (ctx) ->
        # startTime = new Date().getTime()

        minx = @canvas.width
        miny = @canvas.height
        maxx = maxy = 0
        width = @canvas.width
        height = @canvas.height

        # threshold
        redhmin = 320
        redhmax = 360
        redweight = 0
        redmap = []
        # rose
        rhmin = 35
        rhmax = 50
        rweight = 0
        rmap = []
        # blue
        bhmin = 185
        bhmax = 210
        bweight = 0
        bmap = []
        # green
        ghmin = 90
        ghmax = 105
        gweight = 0
        gmap = []

        @ctx.save()
        # @ctx.translate(width, 0);
        # @ctx.scale(-1, 1);
        frame = @ctx.getImageData(0, 0, width, height)
        @ctx.restore()  
        data = frame.data
        len = frame.data.length-4        
        
        for i in [0..len] by 4
            hsl = @cv.rgbToHsl data[i + 0], data[i + 1], data[i + 2]
            h = hsl[0]
            s = hsl[1]
            l = hsl[2]
            if h >= rhmin and h <= rhmax and s >= 20 and s <= 90 and l >= 20 and l <= 90
                # data[i+3] = 0
                rmap.push 1  
                rweight++              
            else
                rmap.push 0
            if h >= bhmin and h <= bhmax and s >= 20 and s <= 90 and l >= 20 and l <= 90
                # data[i+3] = 0
                bmap.push 1  
                bweight++              
            else
                bmap.push 0
            if h >= ghmin and h <= ghmax and s >= 20 and s <= 90 and l >= 20 and l <= 90
                # data[i+3] = 0
                gmap.push 1  
                gweight++              
            else
                gmap.push 0

            if h >= redhmin and h <= redhmax and s >= 20 and s <= 90 and l >= 20 and l <= 90
                # data[i+3] = 0
                redmap.push 1  
                redweight++              
            else
                redmap.push 0

        if redweight > rweight and redweight > gweight and redweight > bweight
            type = 'mountain'
            map = redmap
        else
            if rweight > bweight 
                if rweight > gweight
                    type = 'sand'
                    map = rmap
                else
                    if gweight > bweight
                        type = 'grass'
                        map = gmap
                    else
                        type = 'water'
                        map = bmap
            else 
                if gweight > bweight
                    type = 'grass'
                    map = gmap
                else
                    type = 'water'
                    map = bmap

        # output = @ctx.createImageData width, height
        # dst = output.data
        # for i in [0..map.length-1]
        #     if map[i] is 1
        #         dst[i*4] = 255
        #         dst[i*4+1] = 255
        #         dst[i*4+2] = 255
        #         dst[i*4+3] = 255
        #     else
        #         dst[i*4] = 0
        #         dst[i*4+1] = 0
        #         dst[i*4+2] = 0
        #         dst[i*4+3] = 255

        spot = @scoreMap map

        ctx.putImageData(frame, 0, 0) if ctx?

        # stopTime = new Date().getTime()
        # console.log 'timer detect', stopTime - startTime

        return {type: type, bounds:spot}
        # return {minx:minx, miny:miny, maxx:maxx, maxy:maxy}

    scoreMap: (map) ->
        # startTime = new Date().getTime()
        
        width = @canvas.width
        height = @canvas.height
        val = 0
        target = 0        
        pos = {x:0; y:0}
        for j in [5..height-6]
            for i in [5..width-6]
                index = @cv.XYToIndex(width, i-3,j-3)/4
                val += map[index] + map[index++] + map[index++] + map[index++] + map[index++] + map[index++]
                index += width
                val += map[index] + map[index++] + map[index++] + map[index++] + map[index++] + map[index++]
                index += width
                val += map[index] + map[index++] + map[index++] + map[index++] + map[index++] + map[index++]
                index += width
                val += map[index] + map[index++] + map[index++] + map[index++] + map[index++] + map[index++]
                index += width
                val += map[index] + map[index++] + map[index++] + map[index++] + map[index++] + map[index++]
                index += width
                val += map[index] + map[index++] + map[index++] + map[index++] + map[index++] + map[index++]
                index += width
                val += map[index] + map[index++] + map[index++] + map[index++] + map[index++] + map[index++]    
                if val > target
                    pos = {x:i,y:j}
                    target = val
                val = 0

        # stopTime = new Date().getTime()
        # console.log 'timer scoremap', stopTime - startTime
        #         
        return pos


if typeof module isnt 'undefined' && module.exports
    exports.BlobDetector = BlobDetector
else 
    window.BlobDetector = BlobDetector
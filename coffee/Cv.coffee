class Cv
    constructor: (@canvas) ->
        @ctx = @canvas.getContext '2d'

    getColorBoundsRect: (imageData, color, maxThreshold) ->
        xMin = imageData.width
        yMin = imageData.height
        xMax = yMax = 0
        
        for i in [0..imageData.length] by 4
            if color is @getPixelColor imageData, i 
                pos = @indexToXY i
                if pos.x < xMin
                    xMin = pos.x
                if pos.y < yMin
                    yMin = pos.y
                if pos.x > xMax
                    xMax = pos.x
                if pos.y > yMax
                    yMax = pos.y
        
        if xMin > xMax or yMin > yMax
            return null
        else
            rect =
                x: xMin
                y: yMin
                width: xMax - xMin
                height: yMax - yMin

            return rect

    getPixelColor: (imageData, pixIndex) ->
        p = [
            imageData[pixIndex],
            imageData[pixIndex + 1],
            imageData[pixIndex + 2]
        ]

        return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);

    getXYPixelColor: (imageData, x, y) ->
        p = [
            imageData[(y * imageData.width * 4) + x * 4],
            imageData[(y * imageData.width * 4) + x * 4 + 1],
            imageData[(y * imageData.width * 4) + x * 4 + 2]
        ]

        return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);

    copyPixels: (imageData, srcRect, destPt) ->

    indexToXY: (width, index) ->
        index = index / 4
        y = Math.floor index / width
        x = index % width

        return {x: x, y: y}

    XYToIndex: (width, x, y) ->
        return (y * width + x) * 4

    split: (img) ->
        red = blue = green = []
        for i in [0..imageData.length] by 4
            red.push imageData[i]
            green.push imageData[i + 1]
            blue.push imageData[i + 2]

        return [red, blue, green]

    rgbToHsl: (r, g, b)->
        r /= 255
        g /= 255
        b /= 255
        max = Math.max(r, g, b)
        min = Math.min(r, g, b)
        sum = max + min
        l = s = h = sum / 2

        if max is min
            h = s = 0
        else
            d = max - min
            if l > 0.5 then s = d / (2 - sum) else s = d / sum
            switch max
                when r then h = (g - b) / d + (g < b ? 6 : 0)
                when g then h = (b - r) / d + 2
                when b then h = (r - g) / d + 4
            h /= 6        

        return [Math.floor(h * 360), Math.floor(s * 100), Math.floor(l * 100)];

    rgbToHex: (r, g, b) ->
        return "#" + @componentToHex(r) + @componentToHex(g) + @componentToHex(b)

    componentToHex: (c) ->
        hex = c.toString(16)
        if hex.length is 1 then ret = "0" + hex else ret = hex
        return ret

    convolute: (pixels, weights, opaque) ->
        side = Math.round(Math.sqrt(weights.length))
        halfSide = Math.floor(side/2);
        src = pixels.data
        sw = pixels.width
        sh = pixels.height

        # pad output by the convolution matrix
        w = sw
        h = sh
        output = @ctx.createImageData w, h
        dst = output.data
        # go through the destination image pixels
        alphaFac = opaque ? 1 : 0;
        for y in [0..h-1]
            for x in [0..w-1]
                dstOff = (y*w+x)*4
                # calculate the weighed sum of the source image pixels that
                # fall under the convolution matrix
                r = g = b = a = 0
                for wy in [0..side-1]
                    for wx in [0..side-1]
                        scy = y + wy - halfSide;
                        scx = x + wx - halfSide;
                        if scy >= 0 and scy < sh and scx >= 0 and scx < sw
                            srcOff = (scy*sw+scx)*4
                            wt = weights[wy*side+wx]
                            r += src[srcOff] * wt
                            g += src[srcOff+1] * wt
                            b += src[srcOff+2] * wt
                            a += src[srcOff+3] * wt
                dst[dstOff] = r
                dst[dstOff+1] = g
                dst[dstOff+2] = b
                dst[dstOff+3] = a + alphaFac*(255-a)

        output.data = dst
        return output

if typeof module isnt 'undefined' && module.exports
    exports.Cv = Cv
else 
    window.Cv = Cv
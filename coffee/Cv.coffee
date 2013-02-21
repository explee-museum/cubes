class Cv
    constructor: (@canvas) ->
        @ctx = @canvas.getContext '2d'

    getColorBoundsRect: (imageData, color, threshold) ->
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

        return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6)

    getXYPixelColor: (imageData, x, y) ->
        data = imageData.data
        p = [
            data[(y * imageData.width * 4) + x * 4],
            data[(y * imageData.width * 4) + x * 4 + 1],
            data[(y * imageData.width * 4) + x * 4 + 2]
        ]

        return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6)

    copyPixels: (srcImageData, srcRect, destImageData, destPt) ->
        @canvas.width = @canvas.width
        # We grab the part that we want to copy
        @ctx.putImageData srcImageData, 0, 0
        
        rectData = @ctx.getImageData srcRect.x, srcRect.y, srcRect.w, srcRect.h
        @canvas.width = @canvas.width
        # We copy the dest image
        @ctx.putImageData destImageData, 0, 0        
        
        # We copy the new pixels
        @ctx.putImageData rectData, destPt.x, destPt.y

        # We grab the result
        finalImageData = @ctx.getImageData 0, 0, destImageData.width, destImageData.height
        return finalImageData

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

        return [Math.floor(h * 360), Math.floor(s * 100), Math.floor(l * 100)]

    rgbToHex: (r, g, b) ->
        return "#" + @componentToHex(r) + @componentToHex(g) + @componentToHex(b)

    componentToHex: (c) ->
        hex = c.toString(16)
        if hex.length is 1 then ret = "0" + hex else ret = hex
        return ret

    convertBounds: (bounds, incanvas, outcanvas) ->
        wProportion = outcanvas.width / incanvas.width
        hProportion = outcanvas.height / incanvas.height
        x = Math.floor bounds.x
        y = Math.floor bounds.y

        newBounds = 
            x: x * wProportion
            y: y * hProportion

        return newBounds

    convolute: (imageData, weights, opaque) ->
        side = Math.round(Math.sqrt(weights.length))
        halfSide = Math.floor(side/2)
        src = imageData.data
        sw = imageData.width
        sh = imageData.height

        # pad output by the convolution matrix
        w = sw
        h = sh
        output = @ctx.createImageData w, h
        dst = output.data

        # dst.set(imageData.data)
        # go through the destination image imageData
        alphaFac = opaque ? 1 : 0
        for y in [0..h-1]
            for x in [0..w-1]
                sx = x
                sy = y
                dstOff = (y*w+x)*4
                # calculate the weighed sum of the source image imageData that
                # fall under the convolution matrix
                r = g = b = a = 0
                for wy in [0..side-1]
                    for wx in [0..side-1]
                        scy = sy + wy - halfSide
                        scx = sx + wx - halfSide
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

        return output

    blend: (sourceData1, sourceData2, filter) ->
        width = @canvas.width
        height = @canvas.height

        # We grab pixels datas from sources
        data1 = sourceData1.data
        data2 = sourceData2.data
        blendedData = @ctx.createImageData width, height
        dataBlend = blendedData.data

        console.log data1, data2

        # We grab the smallest size
        len1 = sourceData1.data.length-4
        len2 = sourceData2.data.length-4
        len = Math.min len1, len2

        switch filter
            when "add"
                console.log 'blend:add'
                for i in [0..len] by 4
                    dataBlend[i] = (data1[i] + data2[i] > 255) ? 255 : data1[i] + data2[i]
                    dataBlend[i+1] = (data1[i+1] + data2[i+1] > 255) ? 255 : data1[i+1] + data2[i+1]
                    dataBlend[i+2] = (data1[i+2] + data2[i+2] > 255) ? 255 : data1[i+2] + data2[i+2]
            when "multiply"
                console.log 'blend:multiply'
                for i in [0..len] by 4
                    dataBlend[i] = (data1[i] + data2[i]) / 255
                    dataBlend[i+1] = (data1[i+1] + data2[i+1]) / 255
                    dataBlend[i+2] = (data1[i+2] + data2[i+2]) / 255
            when "difference" 
                console.log 'blend:difference'
                for i in [0..len] by 4
                    dataBlend[i] = @fastAbs data1[i] - data2[i]
                    dataBlend[i+1] = @fastAbs data1[i+1] - data2[i+1]
                    dataBlend[i+2] = @fastAbs data1[i+2] - data2[i+2]
                    dataBlend[i+3] = @fastAbs data1[i+3] - data2[i+3]
            when "differenceAverage"
                for i in[0..len] by 4
                    average1 = (data1[i] + data1[i+1] + data1[i+2]) / 3
                    average2 = (data2[i] + data2[i+1] + data2[i+2]) / 3
                    diff = (@fastAbs(average1 - average2) > 20) ? 255 : 0 
                    target[i] = diff
                    target[i+1] = diff
                    target[i+2] = diff
                    target[i+3] = 255

        console.log 'blended data', blendedData.data
        return blendedData

    # Return the Abs value (bitwise trick)
    fastAbs: (value) ->                
        return (value ^ (value >> 31)) - (value >> 31)

    # If value is in thresholds, return some white, else return black
    threshold: (srcImageData, rule, value, colorOut) ->
        width = srcImageData.width
        height = srcImageData.height
        data = srcImageData.data
        len = srcImageData.data.length - 4

        thresholdImageData = @ctx.createImageData width, height
        dataThreshold = thresholdImageData.data
        switch rule
            when "<" 
                for i in[0..len] by 4
                    average = (data[i] + data[i+1] + data[i+2]) / 3
                    if average < value 
                        dataThreshold[i] = colorOut
            when ">"
                for i in[0..len] by 4
                    average = (data[i] + data[i+1] + data[i+2]) / 3
                    if average > value 
                        dataThreshold[i] = colorOut
            when "!"
                for i in[0..len] by 4
                    average = (data[i] + data[i+1] + data[i+2]) / 3
                    if average != value 
                        dataThreshold[i] = colorOut
            when "==="
                for i in[0..len] by 4
                    average = (data[i] + data[i+1] + data[i+2]) / 3
                    if average is value 
                        dataThreshold[i] = colorOut

        return thresholdImageData

window.Cv = Cv
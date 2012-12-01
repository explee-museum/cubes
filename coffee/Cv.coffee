class Cv
    constructor: () ->

    getColorBoundsRect: (imageData, color, maxThreshold) ->
        xMin = imageData.width
        yMin = imageData.height
        xMax = yMax = 0
        
        for i in [0..imageData.length] by 4
            if color is @getPixelColor imageData, i 
                pos = indexToXY i
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

    indexToXY: (imageData, index) ->
        index = index / 4
        y = Math.floor index / imageData.width
        x = index - y

        return {x: x, y: y}

    XYToIndex: (imageData, x, y) ->
        return (y * imageData.width * 4) + x * 4

    split: (img) ->
        red = blue = green = []
        for i in [0..imageData.length] by 4
            red.push imageData[i]
            green.push imageData[i + 1]
            blue.push imageData[i + 2]

        return [red, blue, green]


if typeof module isnt 'undefined' && module.exports
    exports.Cv = Cv
else 
    window.Cv = Cv
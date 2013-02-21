class WeatherElement
    constructor: (@posX=0, @posY=0) ->



class Cloud extends WeatherElement
    constructor: (@posX=0, @posY=0) ->
        @image = new Image()
        @image.src = 'img/cloud.png'

        r = Math.random()
        @width = Math.round(r*251)
        @height = Math.round(r*188)

    draw: (ctx) ->
        ctx.globalAlpha = 0.2
        ctx.drawImage @image, @posX, @posY, @width, @height

if typeof module isnt 'undefined' && module.exports
    exports.Cloud = Cloud
else 
    window.Cloud = Cloud


class Snow extends WeatherElement
    constructor: (@posX=0, @posY=0) ->
        @image = new Image()
        @image.src = 'img/snow.png'
        @width = 251
        @height = 188

    draw: (ctx) ->
        ctx.drawImage @image, @posX, @posY, @width, @height

window.Snow = Snow

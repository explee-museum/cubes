class People
    constructor: (@posX, @posY, @spriteElement=null) ->
        @path = []
        @state = 'IDLE'
        @goal = 'NONE'
        @age = 0

    walk: () ->
        @posX += Math.floor(Math.random() * 4) - 2
        @posY += Math.floor(Math.random() * 4) - 2

    draw: (ctx) ->
        ctx.drawImage @spriteElement.spritesheet.image, 0, 0, 8, 8, @posX, @posY, 8, 8
    
if typeof module isnt 'undefined' && module.exports
    exports.People = People
else 
    window.People = People
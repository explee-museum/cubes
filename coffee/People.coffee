class People
    constructor: () ->
        @posX = 0
        @posY = 0
        @spriteElem = null
        @path = []
        @state = 'IDLE'
        @goal = 'NONE'
        @age = 0

    walk: () ->
        @poxX += Math.floor Math.random * 4 -2
        @poxY += Math.floor Math.random * 4 -2

    draw: () ->
    
if typeof module isnt 'undefined' && module.exports
    exports.People = People
else 
    window.People = People
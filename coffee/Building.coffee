class Building
    constructor: (@type) ->
        @spriteElem = null
        @posX = 0
        @posY = 0
    
if typeof module isnt 'undefined' && module.exports
    exports.Building = Building
else 
    window.Building = Building
class SpriteElement
    constructor: (@spritesheet, @i, @j) ->
    

if typeof module isnt 'undefined' && module.exports
    exports.SpriteElement = SpriteElement
else 
    window.SpriteElement = SpriteElement    

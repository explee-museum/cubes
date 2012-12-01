class Spritesheet
    constructor: (@path, @offsetX=0, @offsetY=0) ->
        @image = new Image()
        @image.src = @path


if typeof module isnt 'undefined' && module.exports
    exports.Spritesheet = Spritesheet
else 
    window.Spritesheet = Spritesheet
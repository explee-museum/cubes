class Spritesheet
    constructor: (@path, @offset) ->
        @image = new Image()
        @image.src = @path


if typeof module isnt 'undefined' && module.exports
    exports.Spritesheet = Spritesheet
else 
    window.Spritesheet = Spritesheet
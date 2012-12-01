class MapElement
    constructor: (@type, spritesheetGlobal, size) ->
        @sprites = null
        @tiles = []
        switch @type
            when "water"
                @sprites = [new SpriteElement(spritesheetGlobal, 0, 1), new SpriteElement(spritesheetGlobal, 1, 1)]
            when "grass"
                @sprites = [new SpriteElement(spritesheetGlobal, 0, 0), new SpriteElement(spritesheetGlobal, 1, 0)]
            when "sand"
                @sprites = [new SpriteElement(spritesheetGlobal, 0, 2), new SpriteElement(spritesheetGlobal, 1, 2)]
            when "mountain"
                @sprites = [new SpriteElement(spritesheetGlobal, 0, 3)]

        @size =  size / spritesheetGlobal.offset
        @building = null
        @init()

    init: () ->
        for i in [0...@size]
            temp = []
            for j in [0...@size]
                numTem = Math.round(Math.random() * (@sprites.length-1))
                temp.push @sprites[numTem]

            @tiles.push temp

    draw: (ctx, x, y) ->
        for i in [0...@size]
            for j in [0...@size]
                # console.log 'drawing tile...'
                spriteElem = @tiles[i][j]
                # ctx.drawImage spriteElem.spritesheet.image, spriteElem.i * spriteElem.spritesheet.offset, spriteElem.j * spriteElem.spritesheet.offset, i*spriteElem.spritesheet.offset, j*spriteElem.spritesheet.offset, x*50*i*10, y*50*j*10, 10, 10 
                ctx.drawImage spriteElem.spritesheet.image, spriteElem.i * 10, spriteElem.j * 10, 10, 10, x*50+i*10, y*50+j*10, 10, 10


                    

if typeof module isnt 'undefined' && module.exports
    exports.MapElement = MapElement
else 
    window.MapElement = MapElement
     
    
class Map
    constructor: (width, height, @tiles=[]) ->
        @sizeCase = 50
        @widthMap = Math.round(width / @sizeCase)
        @heightMap = Math.round(height / @sizeCase)

        @tiles = []

        @spritesheet = new Spritesheet 'img/spriteGlobal.png', 10
    

    init: () ->
        centerX = Math.round(@widthMap/2)-2
        centerY = Math.floor(@heightMap/2)

        for i in [0..@widthMap]
            tempArray = []
            for j in [0..@heightMap]
                if i in [centerX-3..centerX+2] && j in [centerY-1..centerY+1]
                    r = Math.random()
                    if r <= 0.05
                        mapElement = new MapElement 'mountain', @spritesheet, @sizeCase
                    else if r > 0.1 && r < 0.2
                        mapElement = new MapElement 'sand', @spritesheet, @sizeCase
                    else
                        mapElement = new MapElement 'grass', @spritesheet, @sizeCase
                else
                    mapElement = new MapElement 'water', @spritesheet, @sizeCase
                tempArray.push mapElement
            
            @tiles.push tempArray

    randomMap: () ->
        console.log 'randomize'
        
    addMapElement: (type, i, j, ctx) ->
        @tiles[i][j] = new MapElement type, @spritesheet, @sizeCase
        @draw ctx

    draw: (ctx) ->
        console.log 'drawing...'
        console.log @widthMap
        for i in [0..@widthMap]
            for j in [0..@heightMap]
                console.log 'draw tile'
                @tiles[i][j].draw ctx, i, j



if typeof module isnt 'undefined' && module.exports
    exports.Map = Map
else 
    window.Map = Map
     

class Map
    constructor: (@ctx, width, height, @tiles=[]) ->
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
                if i in [centerX-3..centerX+3] && j in [centerY-2..centerY+2]
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

        for i in [0..@widthMap]
            for j in [0..@heightMap]
                @addShiny i, j

    addShiny: (i, j) ->
        if @tiles[i][j].type != 'water'
            if @tiles[i-1][j]? && @tiles[i-1][j].type != @tiles[i][j].type
                for k in [0..4]
                    r = Math.random()
                    if r > 0.7
                        @tiles[i][j].changePixel 0, k, @tiles[i-1][j].sprites
            if @tiles[i+1][j]? && @tiles[i+1][j].type != @tiles[i][j].type
                for k in [0..4]
                    r = Math.random()
                    if r > 0.7
                        @tiles[i][j].changePixel 4, k, @tiles[i+1][j].sprites

            if @tiles[i][j-1]? && @tiles[i][j-1].type != @tiles[i][j].type
                for k in [0..4]
                    r = Math.random()
                    if r > 0.7
                        @tiles[i][j].changePixel k, 0, @tiles[i][j-1].sprites

            if @tiles[i][j+1]? && @tiles[i][j+1].type != @tiles[i][j].type
                for k in [0..4]
                    r = Math.random()
                    if r > 0.7
                        @tiles[i][j].changePixel k, 4, @tiles[i][j+1].sprites


    randomMap: () ->
        console.log 'randomize'
        
    addMapElement: (type, i, j) ->        
        @tiles[i][j] = new MapElement type, @spritesheet, @sizeCase
        @addShiny i, j
        @draw()

    draw: () ->
        for i in [0..@widthMap]
            for j in [0..@heightMap]
                @tiles[i][j].draw @ctx, i, j

if typeof module isnt 'undefined' && module.exports
    exports.Map = Map
else 
    window.Map = Map
class Map
    constructor: (width, height, @tiles=[]) ->
        @sizeCase = 50
        @widthMap = Math.round(width / @sizeCase)
        @heightMap = Math.round(height / @sizeCase)

        @spritesheet = new Spritesheet 'img/spriteGlobal.png', 10
    
        

    init: () ->
        @tiles = []
        for i in [0..@widthMap]
            tempArray = []
            for j in [0..@heightMap]
                mapElement = new MapElement 'water', @spritesheet, @sizeCase
                tempArray.push mapElement
            
            @tiles.push tempArray

    randomMap: () ->
        console.log 'randomize'

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
     

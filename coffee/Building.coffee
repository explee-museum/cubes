class Building
    constructor: (@type, spritesheet) ->
        @spriteElems = []
        @posX = 0
        @posY = 0

        BUILDING_TYPE_TEMPLE = 0
        BUILDING_TYPE_HOUSE = 1
        BUILDING_TYPE_FARM = 2
        BUILDING_TYPE_GRANARY = 3
        BUILDING_TYPE_PASTURE = 4
        BUILDING_TYPE_SAWMILL = 5
        BUILDING_TYPE_HUNTING_LODGE = 6
        BUILDING_TYPE_HARBOR = 7

        switch @type
            when BUILDING_TYPE_TEMPLE
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, j

            when BUILDING_TYPE_HOUSE
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 2+j

            when BUILDING_TYPE_GRANARY
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 4+j

            when BUILDING_TYPE_FARM
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 6+j

            when BUILDING_TYPE_PASTURE
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 8+j

            when BUILDING_TYPE_SAWMILL
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 10+j

            when BUILDING_TYPE_HUNTING_LODGE
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 12+j

            when BUILDING_TYPE_HARBOR
                for i in [0..1]
                    for j in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 14+j


    draw: (ctx, x, y) ->
        x = @posX*50 + 2*10
        y = @posY*50 + 2*10

        for i, elem in @spriteElems
            if i <= 2
                ctx.drawImage elem.spritesheet.image, 0, 0, 10, 10, x, y, 10, 10
            else
                ctx.drawImage elem.spritesheet.image, 0, 0, 10, 10, x, y, 10, 10

    
if typeof module isnt 'undefined' && module.exports
    exports.Building = Building
else 
    window.Building = Building
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
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, j

            when BUILDING_TYPE_HOUSE
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 2+j

            when BUILDING_TYPE_GRANARY
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 4+j

            when BUILDING_TYPE_FARM
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 6+j

            when BUILDING_TYPE_PASTURE
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 8+j

            when BUILDING_TYPE_SAWMILL
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 10+j

            when BUILDING_TYPE_HUNTING_LODGE
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 12+j

            when BUILDING_TYPE_HARBOR
                for j in [0..1]
                    for i in [0..1]
                        @spriteElems.push new SpriteElement spritesheet, i, 14+j

    draw: (ctx) ->
        x = @posX*50 + 2*10
        y = @posY*50 + 2*10

        ctx.drawImage @spriteElems[0].spritesheet.image, @spriteElems[0].i*10, @spriteElems[0].j*10, 10, 10, x, y, 10, 10
        ctx.drawImage @spriteElems[1].spritesheet.image, @spriteElems[1].i*10, @spriteElems[1].j*10, 10, 10, x+10, y, 10, 10
        ctx.drawImage @spriteElems[2].spritesheet.image, @spriteElems[2].i*10, @spriteElems[2].j*10, 10, 10, x, y+10, 10, 10
        ctx.drawImage @spriteElems[3].spritesheet.image, @spriteElems[3].i*10, @spriteElems[3].j*10, 10, 10, x+10, y+10, 10, 10


    
if typeof module isnt 'undefined' && module.exports
    exports.Building = Building
else 
    window.Building = Building
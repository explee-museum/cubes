class Game
    constructor: (@ctxFront, @ctxBack, @width, @height) ->
        @resources = []
        @map = null
        @peoples = []
        @buildings = []
        @technologies = []
        @priorities = [] 
        @fps = 50
        
    
    init: () ->
        # First, we initialize all the spritesheets

        @map = new Map(@width, @height)
        @map.init()

        @map.draw(@ctxBack)



    loop: () ->


    nextTurn: () ->
        console.log "nextTurn"
        #food expanses
        sum = peoples.length*FOOD_COMSUPTION
        if  sum > ressources[FOOD]
            numberOfDeath = sum - ressources[FOOD]
            ressources[FOOD] = 0
            @priorities[PRIORITY_FOOD] = numberOfDeath * 2
        else
            @priorities[PRIORITY_FOOD] = - ressources[FOOD]

        #Earn buildings effects
        # for buiding in buildings
        #     switch building.type
        #         when 




if typeof module isnt 'undefined' && module.exports
    exports.Game = Game
else 
    window.Game = Game

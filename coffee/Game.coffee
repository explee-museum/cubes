class Game
    cconstructor: () ->
        #MANA,FOOD,WOOD
        @resources = []
        @map = null
        @peoples = []
        @buildings = []
        @technologies = []
        @priorities = [] 

    
    nextTurn: () ->
        console.log "nextTurn"
        sum = 0
        #food expanses
        sum = peoples.length*FOOD_COMSUPTION
        if  sum > ressources[FOOD]
            numberOfDeath = sum - ressources[FOOD]
            ressources[FOOD] = 0
            @priorities[PRIORITY_FOOD] = numberOfDeath * 2
        else
            @priorities[PRIORITY_FOOD] = - ressources[FOOD]

        #Earn buildings effects
        for buiding in buildings
            switch building.type
                when 
class Game
    constructor: (@ctxFront, @ctxBack, @width, @height) ->
        @resources = []
        @map = null
        @peoples = []
        @buildings = []
        @technologies = []
        @priorities = [] 

    
    nextTurn: () ->
        console.log "nextTurn"
        #food expanses
        sum = @peoples.length * FOOD_COMSUPTION
        if  sum > ressources[FOOD]
            numberOfDeath = sum - ressources[FOOD]
            ressources[FOOD] = 0
            @priorities[PRIORITY_FOOD] = numberOfDeath * 2
        else
            @priorities[PRIORITY_FOOD] = - ressources[FOOD]

        #Earn buildings effects
        foodCapacity = 20 #basic food capacity
        maxPeople = 5 #basic max of people
        for buiding in @buildings
            switch building.type
                when BUILDING_TYPE_TEMPLE
                    ressources[MANA]++
                when BUILDING_TYPE_FARM
                    foodToAdd += 4
                when BUILDING_TYPE_PASTURE
                    foodToAdd += 6
                when BUILDING_TYPE_HUNTING_LODGE
                    foodToAdd += 2
                when BUILDING_TYPE_HARBOR
                    #depends of boats :)
                when BUILDING_TYPE_SAWMILL
                    woodToAdd += 4
                when BUILDING_TYPE_GRANARY
                    foodCapacity += 20
                when BUILDING_TYPE_HOUSE
                    maxPeople +=7

        if ressources[FOOD]+foodToAdd > foodCapacity
            #Our peoples need more granary!
            @priorities[PRIORITY_GRANARY] = @ressources[FOOD]+foodToAdd - foodCapacity
            foodToAdd = foodCapacity - ressources[FOOD] 

        @ressources[FOOD] = foodCapacity
        @ressources[WOOD] += woodToAdd
        
        #Calculate if we need to build more temples
        
        #kill peoples
        killCounter = numberOfDeath
        #while killCounter > 0
        #   killCounter--
        #   peoples.delete[random(peoples.length)]


        #create peoples
        if numberOfDeath > 0
            #create 1/4 peoples size * random factor
        else
            #create 1/2 peoples size * random factor

        #build buildings! (only 1 per turn)
        maxIndex = 0
        for  k,priority in @priorities
            if priority > @priorities[maxIndex]
                maxIndex = k
        
        commonSenseBuild maxIndex
        

    commonSenseBuild: (maxIndex) ->
        #PRIORITY_IDDLE = 0
        #PRIORITY_FOOD = 1
        #PRIORITY_WOOD = 2
        #PRIORITY_FAITH = 3
        #PRIORITY_GRANARY = 4
        switch maxIndex
            when PRIORITY_IDDLE
            when PRIORITY_GRANARY
                if build BUILDING_TYPE_GRANARY
                    @priorities[PRIORITY_GRANARY] = 0
                else
                    @priorities[PRIORITY_WOOD] += GRANARY_COST
            when PRIORITY_WOOD
                if build BUILDING_TYPE_SAWMILL
                    @priorities[PRIORITY_WOOD] = 0
                else
                    @priorities[PRIORITY_WOOD] += SAWMILL_COST
            when PRIORITY_FAITH
                if build BUILDING_TYPE_TEMPLE
                    @priorities[PRIORITY_FAITH] = 0
                else
                    @priorities[PRIORITY_WOOD] += TEMPLE_COST
            when PRIORITY_FOOD
                if build BUILDING_TYPE_PASTURE or build BUILDING_TYPE_FARM or build BUILDING_TYPE_HUNTING_LODGE
                    @priorities[PRIORITY_SAWMILL] = 0
                else
                    #we majorate by the strongest cost
                    @priorities[PRIORITY_WOOD] += PASTURE_COST

    #We can only build on empty cases
    build: (type) ->
        #BUILDING_TYPE_TEMPLE = 0
        #BUILDING_TYPE_HOUSE = 1
        #BUILDING_TYPE_FARM = 2
        #BUILDING_TYPE_GRANARY = 3
        #BUILDING_TYPE_PASTURE = 4
        #BUILDING_TYPE_SAWMILL = 5
        #BUILDING_TYPE_HUNTING_LODGE = 6
        #BUILDING_TYPE_HARBOR = 7
        if noSlotsLeft then return false
        switch type
            when BUILDING_TYPE_TEMPLE
                if TEMPLE_COST > @ressources[WOOD] then return false
                #create a new building
                return true
            when BUILDING_TYPE_HUNTING_LODGE
                if GRANARY_COST > @ressources[WOOD] then return false
                #create a new building
                return true
            when BUILDING_TYPE_PASTURE 
                if GRANARY_COST > @ressources[WOOD] or !@technologies[TECH_BREEDING] then return false
                #create a new building
                return true
           
            
            
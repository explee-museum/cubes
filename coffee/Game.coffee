class Game
    constructor: (@ctxFront, @ctxBack, @width, @height) ->
        @resources = []
        @map = null
        @peoples = []
        @buildings = []
        @technologies = []
        @priorities = [] 
        @fps = 50
        
        @interval = null
        @realInterval = 0

        # Sprite for peoples
        @spritePeople = new Spritesheet 'img/spritePeople.png', 8
        @spritePeopleElements = [] 
        @spritePeopleElements.push new SpriteElement(@spritePeople, 0, 0)
        @spritePeopleElements.push new SpriteElement(@spritePeople, 1, 0)
        @spritePeopleElements.push new SpriteElement(@spritePeople, 2, 0)
        @spritePeopleElements.push new SpriteElement(@spritePeople, 3, 0)
    
        @BUILDING_TYPE_TEMPLE = 0
        @BUILDING_TYPE_HOUSE = 1
        @BUILDING_TYPE_FARM = 2
        @BUILDING_TYPE_GRANARY = 3
        @BUILDING_TYPE_PASTURE = 4
        @BUILDING_TYPE_SAWMILL = 5
        @BUILDING_TYPE_HUNTING_LODGE = 6
        @BUILDING_TYPE_HARBOR = 7

        #BUILDING COSTS
        @GRANARY_COST = 10
        @TEMPLE_COST = 20
        @HOUSE_COST = 5
        @FARM_COST = 2
        @HUNTING_LODGE_COST = 2
        @PASTURE_COST = 3
        @HARBOR_COST = 5

        #DIVERS
        @FOOD_COMSUPTION = 1

        #PRIORITIES
        @PRIORITY_IDDLE = 0
        @PRIORITY_FOOD = 1
        @PRIORITY_WOOD = 2
        @PRIORITY_FAITH = 3
        @PRIORITY_GRANARY = 4
        @PRIORITY_HOUSE = 5


        #TECH
        @TECH_FIRE = 0
        @TECH_BREEDING = 1
        
        @TECH_WHEEL = 3
        @TECH_AGRICULTURE = 4

        @TECH_PAPER = 6
        @TECH_MAP = 7
        @TECH_ARCHITECTURE = 8

        @TECH_FISH = 10

        #resources
        @MANA = 0
        @FOOD = 1
        @WOOD = 2


    init: () ->
        # First, we initialize all the spritesheets
        @map = new Map(@width, @height)
        @map.init()
        @map.draw(@ctxBack)


        @resources = [10,200,0]

        centerX = Math.round(@map.widthMap/2)
        centerY = Math.floor(@map.heightMap/2)
        for i in [1..10]
            r = Math.round(Math.random() * (@spritePeopleElements.length-1))
            people = new People centerX*50, centerY*50, @spritePeopleElements[r]
            people.draw(@ctxFront)
            @peoples.push people

        #Then we start with 1 House, 1 hunting lodge, and 1 sawmill
        @build @BUILDING_TYPE_HOUSE
        @build @BUILDING_TYPE_HUNTING_LODGE
        @build @BUILDING_TYPE_SAWMILL

        @interval = setInterval @myLoop, 100

    myLoop: () =>
        # Clear front canvas
        @ctxFront.clearRect 0, 0, @width, @height
        
        document.getElementById('pop_count').innerHTML = @peoples.length
        document.getElementById('mana_count').innerHTML = @resources[0]

        if @realInterval % 30 == 0
            @nextTurn()


        # Perform actions
        for people in @peoples
            people.walk()
            people.draw @ctxFront

        @realInterval += 1



    nextTurn: () ->
        console.log "nextTurn"
        #food expanses
        sum = @peoples.length * @FOOD_COMSUPTION
        if  sum > @resources[@FOOD]
            numberOfDeath = sum - @resources[@FOOD]
            @resources[@FOOD] = 0
            @priorities[@PRIORITY_FOOD] = numberOfDeath * 2
        else
            @priorities[@PRIORITY_FOOD] = - @resources[@FOOD]

        foodCapacity = 20 #basic food capacity
        foodToAdd = 0
        woodToAdd = 0
        maxPeople = 5 #basic max of people
        for buiding in @buildings
            switch building.type
                when @BUILDING_TYPE_TEMPLE
                    @resources[@MANA]++
                when @BUILDING_TYPE_FARM
                    foodToAdd += 4
                when @BUILDING_TYPE_PASTURE
                    foodToAdd += 6
                when @BUILDING_TYPE_HUNTING_LODGE
                    foodToAdd += 2
                    #depends of boats :)
                when @BUILDING_TYPE_SAWMILL
                    woodToAdd += 4
                when @BUILDING_TYPE_GRANARY
                    foodCapacity += 20
                when @BUILDING_TYPE_HOUSE
                    maxPeople +=7

        if @resources[@FOOD]+foodToAdd > foodCapacity
            #Our peoples need more granary!
            @priorities[@PRIORITY_GRANARY] = @resources[@FOOD]+foodToAdd - foodCapacity
            foodToAdd = foodCapacity - @resources[@FOOD] 

        @resources[@FOOD] += foodToAdd
        @resources[@WOOD] += woodToAdd
        
        #Calculate if we need to build more temples
        

        console.log "We are "+@peoples.length
        console.log "They gonna die : "+numberOfDeath

        #kill peoples
        killCounter = numberOfDeath
        while killCounter > 0
           killCounter--
           deadIndex = Math.floor(Math.random()*@peoples.length)
           @peoples.splice deadIndex, 1




        #create peoples
        if numberOfDeath > 0
            numberOfBorn = 0.125* Math.random()*@peoples.length
            #create 1/8 peoples size * random factor
        else
            numberOfBorn = 0.250* Math.random()*@peoples.length
            #create 1/4 peoples size * random factor

        bornCounter = Math.floor numberOfBorn
        while bornCounter > 0
            bornCounter--
            p = new People Math.round(@map.widthMap/2)*50, Math.round(@map.heightMap/2)*50, @spritePeopleElements[0]
            @peoples.push(p)
            

        #build buildings! (only 1 per turn)
        maxIndex = 0
        for  k,priority in @priorities
            if priority > @priorities[maxIndex]
                maxIndex = k
        console.log "______________________________________________________________"
        console.log "Want to build food : " + @priorities[@PRIORITY_FOOD]
        console.log "PRIORITY : " + maxIndex + "| Value : " + @priorities[maxIndex]
        

        @commonSenseBuild maxIndex
        

    commonSenseBuild: (maxIndex) ->
        #PRIORITY_IDDLE = 0
        #PRIORITY_FOOD = 1
        #PRIORITY_WOOD = 2
        #PRIORITY_FAITH = 3
        #PRIORITY_GRANARY = 4
        switch maxIndex
            #when PRIORITY_IDDLE

            when @PRIORITY_GRANARY
                if build @BUILDING_TYPE_GRANARY
                    @priorities[@PRIORITY_GRANARY] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @GRANARY_COST
            when @PRIORITY_WOOD
                if build @BUILDING_TYPE_SAWMILL
                    @priorities[@PRIORITY_WOOD] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @SAWMILL_COST
            when @PRIORITY_FAITH
                if build @BUILDING_TYPE_TEMPLE
                    @priorities[@PRIORITY_FAITH] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @TEMPLE_COST
            when @PRIORITY_FOOD
                if build @BUILDING_TYPE_PASTURE or build @BUILDING_TYPE_FARM or build BUILDING_TYPE_HUNTING_LODGE
                    @priorities[@PRIORITY_FOOD] = 0

                else
                    #we majorate by the strongest cost
                    @priorities[@PRIORITY_WOOD] += @PASTURE_COST



    #Waiting for a integer : building type
    #We can only build on empty slot
    build: (type) ->
        #BUILDING_TYPE_TEMPLE = 0
        #BUILDING_TYPE_HOUSE = 1
        #BUILDING_TYPE_FARM = 2
        #BUILDING_TYPE_GRANARY = 3
        #BUILDING_TYPE_PASTURE = 4
        #BUILDING_TYPE_SAWMILL = 5
        #BUILDING_TYPE_HUNTING_LODGE = 6
        #BUILDING_TYPE_HARBOR = 7

        
        switch type
            when @BUILDING_TYPE_TEMPLE
                if @TEMPLE_COST > @resources[@WOOD] then return false
                #find a slot for the building
                pos = @findSlot "sand"
                if pos[0] == -1 
                    pos = @findSlot "grass"
                    if pos[0] == -1 then return true #we don't build it, and we can't :(
                building = new Building @BUILDING_TYPE_TEMPLE
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[WOOD] -= @TEMPLE_COST
                return true

            when @BUILDING_TYPE_HUNTING_LODGE
                if @HUNTING_LODGE_COST > @resources[@WOOD] then return false
                #create a new building
                pos = @findSlot "grass"
                if pos[0] == -1 then return true #we don't build it, and we can't :(
                building = new Building @BUILDING_TYPE_HUNTING_LODGE
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @HUNTING_LODGE_COST
                return true

            when @BUILDING_TYPE_PASTURE 
                if @PASTURE_COST > @resources[@WOOD] or !@technologies[TECH_BREEDING] then return false
                pos = @findSlot "mountain"
                if pos[0] == -1 then return true #we don't build it, and we can't :(
                
                building = new Building @BUILDING_TYPE_PASTURE
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @PASTURE_COST
                return true

            when @BUILDING_TYPE_HOUSE 
                if @HOUSE_COST > @resources[@WOOD] then return false
                pos = @findSlot "grass"
                if pos[0] == -1 then return true
                
                building = new Building @BUILDING_TYPE_HOUSE
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @HOUSE_COST
                return true

            when @BUILDING_TYPE_FARM
                if @FARM_COST > @resources[@WOOD] or !@technologies[@TECH_AGRICULTURE] then return false
                #create a new building
                pos = @findSlot "grass"
                if pos[0] == -1 then return true #we don't build it, and we can't :(
                
                building = new Building @BUILDING_TYPE_FARM
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @FARM_COST
                return true

            when @BUILDING_TYPE_GRANARY 
                if @GRANARY_COST > @resources[@WOOD] then return false
                pos = @findSlot "grass"
                if pos[0] == -1 then return true 
                building = new Building @BUILDING_TYPE_GRANARY
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @GRANARY_COST
                return true

            when @BUILDING_TYPE_SAWMILL 
                if @SAWMILL_COST > @resources[@WOOD] then return false
                pos = @findSlot "mountain"
                if pos[0] == -1
                    pos = @findSlot "grass"
                if pos[0] == -1 then return true 
                building = new Building @BUILDING_TYPE_SAWMILL
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @SAWMILL_COST
                return true

            when @BUILDING_TYPE_HARBOR
                if @HARBOR_COST > @resources[@WOOD] or !@technologies[@TECH_FISH] then return false
                #create a new building
                return true

    #type : string
    #find a slot for a building. Return coord of this slot, or [-1,-1] if not found :(
    findSlot: (searchType) ->
        for i in [0..@map.tiles.widthMap]
            for j in [0..@map.tiles.heightMap]
                if @map.tiles[i][j].type == searchType and @map.tiles[i][j].building == null
                    return [i,j]
        return [-1,-1]




if typeof module isnt 'undefined' && module.exports
    exports.Game = Game
else 
    window.Game = Game

class Game
    constructor: (@ctxFront, @ctxBack, @ctxWeather, @width, @height) ->
        @resources = []
        @map = null
        @peoples = []
        @alivePeople = 0

        @boats = []
        @buildings = []
        @technologies = []
        @priorities = [] 
        @fps = 50

        @weather = 0
        @timeSameWeather = 0

        @weatherElements = []
        @weatherDraw = false

        @interval = null
        @realInterval = 0

        @score = 1
        @scoreTechno = 1

        # Sprite for peoples
        @spritePeople = new Spritesheet 'img/spritePeople.png', 8
        @spritePeopleElements = [] 
        @spritePeopleElements.push new SpriteElement(@spritePeople, 0, 0)
        @spritePeopleElements.push new SpriteElement(@spritePeople, 1, 0)
        @spritePeopleElements.push new SpriteElement(@spritePeople, 2, 0)
        @spritePeopleElements.push new SpriteElement(@spritePeople, 3, 0)

        @spriteBuildings = new Spritesheet 'img/spriteBuildings.png', 10

        @WEATHER_SUN = 0
        @WEATHER_RAIN = 1
        @WEATHER_WARM = 2
        @WEATHER_SNOW = 3

        @BUILDING_TYPE_TEMPLE = 0
        @BUILDING_TYPE_HOUSE = 1
        @BUILDING_TYPE_FARM = 2
        @BUILDING_TYPE_GRANARY = 3
        @BUILDING_TYPE_PASTURE = 4
        @BUILDING_TYPE_SAWMILL = 5
        @BUILDING_TYPE_HUNTING_LODGE = 6
        @BUILDING_TYPE_HARBOR = 7

        @BUILDING_NUMBER_HARBOR = 0

        #BUILDING COSTS
        @GRANARY_COST = 20
        @TEMPLE_COST = 40
        @HOUSE_COST = 10
        @FARM_COST = 10
        @HUNTING_LODGE_COST = 10
        @PASTURE_COST = 20
        @HARBOR_COST = 30
        @SAWMILL_COST = 10
        @BOAT_COST = 5

        #DIVERS
        @FOOD_COMSUPTION = 1
        @MAX_AGE = 50
        @DEATH_FROM_ICE = 0


        #PRIORITIES
        @PRIORITY_IDDLE = 0
        @PRIORITY_FOOD = 1
        @PRIORITY_WOOD = 2
        @PRIORITY_FAITH = 3
        @PRIORITY_GRANARY = 4
        @PRIORITY_HOUSE = 5
        @PRIORITY_HARBOR = 6

        #FOOD
        @FOOD_FARM = 8
        @FOOD_PASTURE = 12
        @FOOD_HUNTING = 4
        @FOOD_HUNTING_FIRE = 6
        @FOOD_BOAT = 2

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

        @resources = [10,10,50]

        for i in [1..10]
            @addPeople()

        #Then we start with 1 House, 2 hunting lodge, and 1 sawmill
        @build @BUILDING_TYPE_HOUSE
        @build @BUILDING_TYPE_HUNTING_LODGE
        @build @BUILDING_TYPE_HUNTING_LODGE
        @build @BUILDING_TYPE_SAWMILL 


        @priorities = [0,0,0,0,0,0,0]
        @technologies = [false, false, false, false, false, false, false, false, false, false, false, false]

        @interval = setInterval @myLoop, 100

    myLoop: () =>
        # Clear front canvas
        @ctxFront.clearRect 0, 0, @width, @height
        
        document.getElementById('pop_count').innerHTML = @alivePeople
        document.getElementById('mana_count').innerHTML = @resources[0]
        document.getElementById('food_count').innerHTML = @resources[1]
        document.getElementById('wood_count').innerHTML = @resources[2]




        if @realInterval % 30 == 0
            @nextTurn()
            @addWeatherElements()

        # if @realInterval % 50 == 0
            # document.getElementById('technos').innerHTML = ''

        if @weatherDraw
            @ctxWeather.clearRect 0, 0, @width, @height
            
            if @weather == @WEATHER_SNOW
                @ctxWeather.globalAlpha = 0.2
                @ctxWeather.fillStyle = 'white'
                @ctxWeather.fillRect 0, 0, @width, @height

            else if @weather == @WEATHER_RAIN
                @ctxWeather.globalAlpha = 0.3
                @ctxWeather.fillStyle = '#6088a4'
                @ctxWeather.fillRect 0, 0, @width, @height

            for elem in @weatherElements
                elem.posX += Math.round(Math.random() * 2)
                elem.posY += 1
                elem.draw @ctxWeather


        # Perform actions
        for people in @peoples
            if !people.isDead and !people.walk()
                #we have to find him a new goal!
                j = Math.round (Math.random() * @map.heightMap)
                i = Math.round (Math.random() * @map.widthMap)
                while (@map.tiles[i][j].type == "water")
                    j = Math.round (Math.random() * @map.heightMap)
                    i = Math.round (Math.random() * @map.widthMap)

                people.findNewGoal i*50,j*50

            people.draw @ctxFront


        for boat in @boats
            if !boat.navigate()

                if @technologies[@MAP]

                    j = boat.srcY+Math.round (Math.random() * 5 -2)
                    i = boat.srcX+Math.round (Math.random() * 5 -2)
                    while (i>0 and j>0 and i< @map.widthMap and j < @map.heightMap and @map.tiles[i][j].type != "water")
                        j = boat.srcY+Math.round (Math.random() * 5 -2)
                        i = boat.srcX+Math.round (Math.random() * 5 -2)

                    boat.findNewGoal i*50+10, j*50+10
                else

                    j = boat.srcY+Math.round (Math.random() * 3 -1)
                    i = boat.srcX+Math.round (Math.random() * 3 -1)
                    while (i>0 and j>0 and i< @map.widthMap and j < @map.heightMap and @map.tiles[i][j].type != "water")
                        j = boat.srcY+Math.round (Math.random() * 3 -1)
                        i = boat.srcX+Math.round (Math.random() * 3 -1)

                    boat.findNewGoal i*50+10, j*50+10

            boat.draw @ctxFront

        for building in @buildings
            building.draw @ctxBack

        @realInterval += 1

    addPeople: () ->

        #trying to find a house to spawn new people
        houses = []
        for building in @buildings
            if building.type == @BUILDING_TYPE_HOUSE
                houses.push building

        if !houses.length > 0
            r = Math.round(Math.random() * (@spritePeopleElements.length-1))
            people = new People Math.round(@map.widthMap/2)*50, Math.round(@map.heightMap/2)*50, @spritePeopleElements[r]     

        else
            index = Math.floor(Math.random() * houses.length)
            r = Math.round(Math.random() * (@spritePeopleElements.length-1))
            people = new People houses[index].posX*50+25, houses[index].posY*50+25, @spritePeopleElements[r]
        
        people.draw(@ctxFront)
        @peoples.push people

        return people

    addWeatherElements: () ->
        if @weather == @WEATHER_SNOW
            r = Math.round(Math.random() * 5) 
            for i in [0..r]
                snow = new Snow Math.round(Math.random()*@width/10) - 100, Math.round(Math.random()*@height)
                @weatherElements.push snow

            @weatherDraw = true

        else if @weather == @WEATHER_WARM
            console.log 'warm'



        else if @weather == @WEATHER_RAIN
            @ctxWeather.globalAlpha = 0.2

            r = Math.random()
            if r > 0.75
                cloud = new Cloud Math.round(Math.random()*@width/15) - 100, Math.round(Math.random()*@height)
                @weatherElements.push cloud

            @weatherDraw = true

    drawWeather: () ->
        if @weather == @WEATHER_SNOW
            @weatherElements = []

            r = Math.round(Math.random() * 10) + 40
            for i in [0..r]
                snow = new Snow Math.round(Math.random()*@width), Math.round(Math.random()*@height)
                @weatherElements.push snow

            @weatherDraw = true

        else if @weather == @WEATHER_WARM
            console.log 'warm'

            @weatherElements = []
            @ctxWeather.clearRect 0, 0, @width, @height

            @ctxWeather.globalAlpha = 0.3
            @ctxWeather.fillStyle = '#f0df44'
            @ctxWeather.fillRect 0, 0, @width, @height

            @weatherDraw = false

        else if @weather == @WEATHER_RAIN
            @weatherElements = []
            @ctxWeather.globalAlpha = 0.2

            r = Math.round(Math.random() * 10) + 5
            for i in [0..r]
                cloud = new Cloud Math.round(Math.random()*@width), Math.round(Math.random()*@height)
                @weatherElements.push cloud

            @weatherDraw = true
                
        else
            console.log 'else'
            @ctxWeather.globalAlpha = 0
            @ctxWeather.clearRect 0, 0, @width, @height

    nextTurn: () ->
        console.log "nextTurn"

        @resources[@MANA]++
        oldWeather = @weather

        foodCapacity = 20
        woodCapacity = 5
        numberOfDeath = 0

        for building in @buildings
            if building.type == @BUILDING_TYPE_GRANARY
                    foodCapacity += 30
            if building.type == @BUILDING_TYPE_SAWMILL
                    woodCapacity += 20




        @alivePeople = @peoples.length
        for people in @peoples
            if people.isDead then @alivePeople--

        #food expanses
        sum = @alivePeople * @FOOD_COMSUPTION
        if  sum > @resources[@FOOD]
            numberOfDeath = sum - @resources[@FOOD]
            @resources[@FOOD] = 0
            @priorities[@PRIORITY_FOOD] = numberOfDeath * 4
        else
            @priorities[@PRIORITY_FOOD] = (foodCapacity - @resources[@FOOD])/3
            @resources[@FOOD] -= sum

         #basic food capacity
        foodToAdd = 0
        woodToAdd = 0
        maxPeople = 5 #basic max of people
        
        for boat in @boats
            x = Math.round(boat.posX/50)
            y = Math.round(boat.posY/50)
            if @map.tiles[x][y]? and @map.tiles[x][y].res > 0 and @map.tiles[x][y] == "water"
                @map.tiles[x][y].res--
                foodToAdd += @FOOD_BOAT


        for building in @buildings
            if @map.tiles[building.posX][building.posY].res <= 0 
                    continue
            @map.tiles[building.posX][building.posY].res--
            switch building.type
                when @BUILDING_TYPE_TEMPLE
                    @resources[@MANA]++
                
                when @BUILDING_TYPE_FARM
                    foodToAdd += @FOOD_FARM
                
                when @BUILDING_TYPE_PASTURE
                    foodToAdd += @FOOD_PASTURE
                
                when @BUILDING_TYPE_HUNTING_LODGE
                    if @technologies[@TECH_FIRE] 
                        foodToAdd += @FOOD_HUNTING_FIRE
                    else
                        foodToAdd += @FOOD_HUNTING
                
                when @BUILDING_TYPE_SAWMILL
                    woodToAdd += 4
                
                when @BUILDING_TYPE_HOUSE
                    if @technologies[@TECH_ARCHITECTURE]
                        maxPeople += 12
                    else
                        maxPeople += 9

        if @resources[@FOOD]+foodToAdd > foodCapacity
            #Our peoples need more granary!
            @priorities[@PRIORITY_GRANARY] = foodToAdd
            foodToAdd = foodCapacity - @resources[@FOOD] 

        if @resources[@WOOD]+woodToAdd > woodCapacity
            woodToAdd = woodCapacity - @resources[@WOOD] 

        @resources[@FOOD] += foodToAdd
        @resources[@WOOD] += woodToAdd


        
        #Calculate if we need to build more temples
        console.log "We are "+@alivePeople
        console.log "They gonna die : "+numberOfDeath

        #kill peoples
        killCounter = numberOfDeath
        while killCounter > 0
           deadIndex = Math.floor(Math.random()*@peoples.length)
           if !@peoples[deadIndex].isDead
                killCounter--
                @peoples[deadIndex].isDead = true
            #@peoples.splice deadIndex, 1



        peoplesToDel = []
        for people ,k in @peoples
            if people.isDead
                people.timeDead++
                if people.timeDead > 5
                    peoplesToDel.push k

        for iPeople in peoplesToDel
            @peoples.splice iPeople, 1



        @priorities[@PRIORITY_FAITH]++

        #create peoples
        if numberOfDeath > 0
            numberOfBorn = 0.125* Math.random()*@alivePeople
            #create 1/8 peoples size * random factor
        else
            numberOfBorn = Math.random()*@alivePeople
            #create 1/4 peoples size * random factor

        for speople, k in @peoples
            speople.age++
            if Math.random() * @MAX_AGE < speople.age
                if !speople.isDead
                    speople.isDead = true

        

        bornCounter = Math.floor numberOfBorn
        while bornCounter > 0
            bornCounter--
            if maxPeople == @alivePeople
                @priorities[@PRIORITY_HOUSE]+=3
            else
                @addPeople()            

        #build buildings! (only 1 per turn)
        maxIndex = 0
        for priority,k in @priorities
            #console.log "in loop : k = " + k + "| priority = " + priority
            if priority > @priorities[maxIndex]
                maxIndex = k
        #console.log "______________________________________________________________"
        #console.log "Want to build food : " + @priorities[@PRIORITY_FOOD]
        #console.log "PRIORITY : " + maxIndex + "| Value : " + @priorities[maxIndex]
        

        @commonSenseBuild maxIndex

        if @weather == @WEATHER_SNOW
            coldDie = Math.random() * 10 < 2
            if coldDie
                if @technologies[@TECH_FIRE]
                    killCounter = 1/10 * @alivePeople
                else
                    killCounter = 1/3 * @alivePeople
                while killCounter > 0
                    deadIndex = Math.floor(Math.random()*@peoples.length)
                    if !@peoples[deadIndex].isDead
                        killCounter--
                        @peoples[deadIndex].isDead = true
                        @DEATH_FROM_ICE++



        #discover Technologies
        if !@technologies[@TECH_FIRE] and @weather == @WEATHER_RAIN and @DEATH_FROM_ICE >= 5
            @discover @TECH_FIRE

        if !@technologies[@TECH_WHEEL]
            mountainCount = 0
            for i in [0..@map.widthMap]
                for j in [0..@map.heightMap]
                    if @map.tiles[i][j].type == "mountain" then mountainCount++
            if mountainCount > 2 then @discover @TECH_WHEEL

        if !@technologies[@TECH_AGRICULTURE] and @technologies[@TECH_WHEEL] and @alivePeople > 50
            @discover @TECH_AGRICULTURE

        if !@technologies[@TECH_BREEDING] and @technologies[@TECH_FIRE]
            hunterCount = 0
            for building in @buildings
                if building.type == @BUILDING_TYPE_HUNTING_LODGE then hunterCount++
            if hunterCount > 5
                @discover @TECH_BREEDING

        if !@technologies[@TECH_PAPER] and @technologies[@TECH_FIRE] and @peoples.length > 100
            @discover @TECH_PAPER


        if !@technologies[@TECH_ARCHITECTURE] and @technologies[@TECH_PAPER] and @peoples.length > 200
            templeCount = 0
            for building in @buildings
                if building.type == @BUILDING_TYPE_TEMPLE then templeCount++
            @discover @TECH_ARCHITECTURE
    

        if !@technologies[@TECH_FISH] and @resources[@WOOD] >= 80
            @discover @TECH_FISH

        if !@technologies[@TECH_FISH] and @resources[@WOOD] >= 80
            @discover @TECH_FISH

        if !@technologies[@TECH_MAP] and @technologies[@TECH_PAPER] and @technologies[@TECH_FISH] and boats.length > 5
            @discover @TECH_MAP

        if oldWeather != @weather
            @timeSameWeather = 0
        else
            @timeSameWeather++

            #effects from time

        if @technologies[@TECH_FISH] and @BUILDING_NUMBER_HARBOR == 0 
            @priorities[@PRIORITY_HARBOR] += 3



    discover: (indexTechno) ->
        @technologies[indexTechno] = true

        name = ''
        if indexTechno == @TECH_ARCHITECTURE
            name = 'architecture'
        else if indexTechno == @TECH_PAPER
            name = 'paper'
        else if indexTechno == @TECH_FIRE
            name = 'fire'
        else if indexTechno == @TECH_BREEDING
            name = 'breeding'
        else if indexTechno == @TECH_WHEEL
            name = 'wheel'
        else if indexTechno == @TECH_AGRICULTURE
            name = 'agriculture'
        else if indexTechno == @TECH_FISH
            name = 'fish'
        else if indexTechno == @TECH_MAP
            name == 'map'

        document.getElementById('technos').innerHTML = 'You just discovered ' + name + '!'

        console.log 'DISCOVERED ' + name

    commonSenseBuild: (maxIndex) ->
        #PRIORITY_IDDLE = 0
        #PRIORITY_FOOD = 1
        #PRIORITY_WOOD = 2
        #PRIORITY_FAITH = 3
        #PRIORITY_GRANARY = 4
        switch maxIndex
            #when PRIORITY_IDDLE

            when @PRIORITY_GRANARY
                if @build @BUILDING_TYPE_GRANARY
                    @priorities[@PRIORITY_GRANARY] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @GRANARY_COST
            when @PRIORITY_WOOD
                if @build @BUILDING_TYPE_SAWMILL
                    @priorities[@PRIORITY_WOOD] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @SAWMILL_COST
            when @PRIORITY_FAITH
                if @build @BUILDING_TYPE_TEMPLE
                    @priorities[@PRIORITY_FAITH] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @TEMPLE_COST
            when @PRIORITY_FOOD
                if @technologies[@TECH_FISH] and @BUILDING_NUMBER_HARBOR > 0 and @resources[@WOOD] > @BOAT_COST and @boats.length < 5
                    @buildABoat()
                    @priorities[@PRIORITY_FOOD] = 0
                else if @build(@BUILDING_TYPE_PASTURE) or @build(@BUILDING_TYPE_FARM) or @build(@BUILDING_TYPE_HUNTING_LODGE)
                    @priorities[@PRIORITY_FOOD] = 0

                else
                    #we majorate by the strongest cost
                    @priorities[@PRIORITY_WOOD] += @PASTURE_COST
            when @PRIORITY_HOUSE
                if @build @BUILDING_TYPE_HOUSE
                    @priorities[@PRIORITY_HOUSE] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @HOUSE_COST

            when @PRIORITY_HARBOR
                if @build @BUILDING_TYPE_HARBOR
                    @priorities[@PRIORITY_HARBOR] = 0
                else
                    @priorities[@PRIORITY_WOOD] += @HARBOR_COST

    #search for a harbor, and build a fucking boat there!
    buildABoat: () ->
        harborList = []
        for building in @buildings
            if building.type == @BUILDING_TYPE_HARBOR
                harborList.push(building)
        if harborList.length > 0
            i = Math.round(Math.random() * harborList.length)
            building = harborList[i]
            @boats.push(new Boat building.posX*50, building.posY*50)




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
                building = new Building @BUILDING_TYPE_TEMPLE, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @TEMPLE_COST
                return true

            when @BUILDING_TYPE_HUNTING_LODGE
                console.log "I WANT TO BUILD HUNTING LODGE :" + @HUNTING_LODGE_COST + " > " + @resources[@WOOD]
                if @HUNTING_LODGE_COST > @resources[@WOOD] then return false
                #create a new building
                pos = @findSlot "grass"
                if pos[0] == -1 then return true #we don't build it, and we can't :(
                building = new Building @BUILDING_TYPE_HUNTING_LODGE, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @HUNTING_LODGE_COST
                console.log "SUCCESS : final wood " + @resources[@WOOD]
                return true

            when @BUILDING_TYPE_PASTURE 
                console.log "I WANT TO BUILD PASTURE :" + @PASTURE_COST + " > " + @resources[@WOOD]
                if !@technologies[@TECH_BREEDING]  or @PASTURE_COST > @resources[@WOOD] then return false
                
                pos = @findSlot "mountain"
                if pos[0] == -1 then return true #we don't build it, and we can't :(
                
                building = new Building @BUILDING_TYPE_PASTURE, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @PASTURE_COST
                console.log "SUCCESS : final wood " + @resources[@WOOD]
                return true

            when @BUILDING_TYPE_HOUSE 
                console.log "I WANT TO BUILD HOUSE :" + @HOUSE_COST + " > " + @resources[@WOOD]
                if @HOUSE_COST > @resources[@WOOD] then return false
                pos = @findSlot "grass"
                if pos[0] == -1 then return true
                
                building = new Building @BUILDING_TYPE_HOUSE, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @HOUSE_COST
                console.log "SUCCESS : final wood " + @resources[@WOOD]
                return true

            when @BUILDING_TYPE_FARM
                console.log "I WANT TO BUILD FARM :" + @FARM_COST + " > " + @resources[@WOOD]
                if @FARM_COST > @resources[@WOOD] or !@technologies[@TECH_AGRICULTURE] then return false
                #create a new building
                pos = @findSlot "grass"
                if pos[0] == -1 then return true #we don't build it, and we can't :(
                
                building = new Building @BUILDING_TYPE_FARM, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @FARM_COST
                console.log "SUCCESS : final wood " + @resources[@WOOD]
                return true

            when @BUILDING_TYPE_GRANARY 
                console.log "I WANT TO BUILD GRANARY :" + @GRANARY_COST + " > " + @resources[@WOOD]
                if @GRANARY_COST > @resources[@WOOD] then return false
                pos = @findSlot "grass"
                if pos[0] == -1 then return true 
                building = new Building @BUILDING_TYPE_GRANARY, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @GRANARY_COST
                console.log "SUCCESS : final wood " + @resources[@WOOD]
                return true

            when @BUILDING_TYPE_SAWMILL 
                console.log "I WANT TO BUILD SAWMILL :" + @SAWMILL_COST + " > " + @resources[@WOOD]
                if @SAWMILL_COST > @resources[@WOOD] then return false
                pos = @findSlot "mountain"
                if pos[0] == -1
                    pos = @findSlot "grass"
                    if pos[0] == -1 then return true 
                building = new Building @BUILDING_TYPE_SAWMILL, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @SAWMILL_COST

                console.log "SUCCESS : final wood " + @resources[@WOOD]
                return true

            when @BUILDING_TYPE_HARBOR

                console.log "I WANT TO BUILD HARBOR :" + @HARBOR_COST + " > " + @resources[@WOOD]
                if @HARBOR_COST > @resources[@WOOD] or !@technologies[@TECH_FISH] then return false
                pos = @findSlot "harbor"
                if pos[0] == -1 then return true
                building = new Building @BUILDING_TYPE_HARBOR, @spriteBuildings
                building.posX = pos[0]
                building.posY = pos[1]
                @map.tiles[pos[0]][pos[1]].building = building
                @buildings.push building
                @resources[@WOOD] -= @HARBOR_COST
                @BUILDING_NUMBER_HARBOR++

                console.log "SUCCESS : final wood " + @resources[@WOOD]
                return true

    #type : string
    #find a slot for a building. Return coord of this slot, or [-1,-1] if not found :(
    findSlot: (searchType) ->
        results = []
        
        if searchType == "harbor"
            console.log "I GONNA BUILD A HARBOR :) "
            for i in [0..@map.widthMap]
                for j in [0..@map.heightMap]
                  # console.log "searching for : " + searchType + " | but i have : " + @map.tiles[i][j].type
                    if @map.tiles[i][j].type == "water" and @map.tiles[i][j].building == null
                        notWaterCounter = 0
                        for co in [-1..2]
                            for ce in [-1..2]
                                if i+co > 0 and j+ce > 0 and i+co < @map.widthMap and j+ce < @map.heightMap and @map.tiles[i+co][j+ce].type != "water"
                                    notWaterCounter++
                        if notWaterCounter > 1
                            results.push([i,j])
            if results.length > 0
                i = Math.floor(Math.random() * results.length)
                return results[i]
            return [-1,-1]


        for i in [0..@map.widthMap]
            for j in [0..@map.heightMap]
                # console.log "searching for : " + searchType + " | but i have : " + @map.tiles[i][j].type
                if @map.tiles[i][j].type == searchType and @map.tiles[i][j].building == null
                    # console.log "@map.tiles[i][j].building : " + @map.tiles[i][j].building
                    results.push([i,j])
        if results.length > 0
            index = Math.floor(Math.random() * results.length)
            return results[index]
        return [-1,-1]


if typeof module isnt 'undefined' && module.exports
    exports.Game = Game
else 
    window.Game = Game

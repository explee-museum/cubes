$ ->
    window.onload = () ->
    # img = new Image()
    # img.src = 'img/spriteGlobal.png'
    # img.onload = () ->
        # CONSTANTS

        #BUILDING TYPES
        BUILDING_TYPE_TEMPLE = 0
        BUILDING_TYPE_HOUSE = 1
        BUILDING_TYPE_FARM = 2
        BUILDING_TYPE_GRANARY = 3
        BUILDING_TYPE_PASTURE = 4
        BUILDING_TYPE_SAWMILL = 5
        BUILDING_TYPE_HUNTING_LODGE = 6
        BUILDING_TYPE_HARBOR = 7

        #BUILDING COSTS
        GRANARY_COST = 10
        TEMPLE_COST = 20
        HOUSE_COST = 5
        FARM_COST = 2
        HUNTING_LODGE_COST = 2
        PASTURE_COST = 3
        HARBOR_COST = 5


        #DIVERS
        FOOD_COMSUPTION = 1


        #PRIORITIES
        PRIORITY_IDDLE = 0
        PRIORITY_FOOD = 1
        PRIORITY_WOOD = 2
        PRIORITY_FAITH = 3
        PRIORITY_GRANARY = 4
        PRIORITY_HOUSE = 5


        #TECH
        TECH_FIRE = 0
        TECH_BREEDING = 1
        
        TECH_WHEEL = 3
        TECH_AGRICULTURE = 4

        TECH_PAPER = 6
        TECH_MAP = 7
        TECH_ARCHITECTURE = 8

        TECH_FISH = 10

        #Ressources
        MANA = 0
        FOOD = 1
        WOOD = 2

        canvasFront = document.getElementById 'front'
        ctxFront = canvasFront.getContext '2d'

        canvasBack = document.getElementById 'back'
        ctxBack = canvasBack.getContext '2d'

        # initialize size
        canvasBack.width = document.width
        canvasBack.height = document.height

        canvasFront.width = document.width
        canvasFront.height = document.height


        game = new Game ctxFront, ctxBack, document.width, document.height
        game.init()



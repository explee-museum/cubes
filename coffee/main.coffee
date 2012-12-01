$ ->

    # CONSTANTS

    #BUILDING TYPES
    BUILDING_TYPE_TEMPLE = 0
    BUILDING_TYPE_HOUSE = 1
    BUILDING_TYPE_FARM = 2
    BUILDING_TYPE_GRANARY = 3
    BUILDING_TYPE_PASTURE = 4
    BUILDING_TYPE_SAWMILL = 5
    BUILDING_TYPE_HUNTING_LODGE = 6
    BUILDING_TYPE_HUNTING_HARBOR = 7

    #DIVERS
    FOOD_COMSUPTION = 1


    #PRIORITIES
    PRIORITY_IDDLE = 0
    PRIORITY_FOOD = 1
    PRIORITY_WOOD = 2
    PRIORITY_FAITH = 3

    #Ressources
    MANA = 0
    FOOD = 1
    WOOD = 2



    canvasFront = document.getElementById 'front'
    ctxFront = canvasFront.getContext '2d'

    canvasBack = document.getElementById 'front'
    ctxBack = canvasBack.getContext '2d'

    # initialize size
    canvasBack.width = document.width
    canvasBack.height = document.height

    canvasFront.width = document.width
    canvasFront.height = document.height

    game = new Game ctxFront, ctxBack, document.width, document.height
    game.init()

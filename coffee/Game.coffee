class Game
    constructor: () ->
        @resources = []
        @map = null
        @peoples = []
        @buildings = []
        @technologies = []

    
    nextTurn: () ->
        console.log "nextTurn"
        var sum = 0;
        #for people in peoples



        #for buiding in buildings
        #    switch building.type
        #        when 
                    
                
            
if typeof module isnt 'undefined' && module.exports
    exports.Game = Game
else 
    window.Game = Game
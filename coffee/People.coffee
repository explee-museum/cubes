class People
    constructor: (@posX, @posY, @spriteElement=null) ->
        @path = []
        @state = 'IDLE'
        @goal = [-1,-1]
        @age = 0

    walk: () ->
        if @goal[0] < 0 
            return false

        if Math.abs(@goal[0] - @posX) < 3 and Math.abs(@goal[1] - @posY) < 3
            return false

        dirX = 0
        dirY = 0
        if @posX > @goal[0]
            dirX = -1
        if @posX < @goal[0]
            dirX = 1
        if @posY > @goal[1]
            dirY = -1
        if @posY < @goal[1]
            dirY = 1

        @posX += Math.floor(Math.random() * 5) - 2 + dirX
        @posY += Math.floor(Math.random() * 5) - 2 + dirY
        return true

    findNewGoal: (x, y) ->
        console.log "GOING TO " + x + "," + y
        @goal = [x,y]


    draw: (ctx) ->
        ctx.drawImage @spriteElement.spritesheet.image, @spriteElement.i*8, @spriteElement.j*8, 8, 8, @posX, @posY, 8, 8
    
if typeof module isnt 'undefined' && module.exports
    exports.People = People
else 
    window.People = People
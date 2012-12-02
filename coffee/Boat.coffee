class Boat
    constructor: (@posX, @posY) ->
        @srcX = Math.round(@posX/50)
        @srcY = Math.round(@posY/50)
        @age = 0
        @goal = [-1,-1]
        @image = new Image()
        @image.src = 'img/boat.png'

    navigate: () ->
        if @goal[0] < 0
            return false

        #to find a new destination
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

        @posX += dirX*0.5
        @posY += dirY*0.5
        return true

    findNewGoal: (x, y) ->
        #console.log "GOING TO " + x + "," + y
        @goal = [x,y]


    draw: (ctx) ->
        ctx.drawImage @image, 0, 0, 10, 20, @posX, @posY, 10, 20

if typeof module isnt 'undefined' && module.exports
    exports.Boat = Boat
else 
    window.Boat = Boat
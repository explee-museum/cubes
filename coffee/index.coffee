$ ->
    window.onload = () ->
        canvas = document.getElementById('c')
        ctx = canvas.getContext('2d')

        canvas.width = document.width
        canvas.height = document.height

        img = new Image()
        img.src = 'img/spriteGlobal.png'

        nbX = canvas.width / 10
        nbY = canvas.height / 10

        for i in [0..nbX]
            for j in [0..nbY]
                r = if Math.random() >= 0.5 then 0 else 10

                ctx.drawImage img, r, 10, 10, 10, i*10, j*10, 10, 10 



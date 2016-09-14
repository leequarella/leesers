class @Mirror
  length: 30

  constructor: (@start_x, @start_y, @position) ->
    @end_x = @start_x + (@length * Math.cos(@angle()))
    @end_y = @start_y + (@length * Math.sin(@angle()))

  draw: (canvas)->
    ctx = canvas.getContext("2d")
    ctx.beginPath()
    ctx.moveTo(@start_x, @start_y)
    ctx.lineTo(@end_x, @end_y)

    ctx.strokeStyle = '#0000ff'
    ctx.stroke()

  angle: ->
    switch @position
      when 1
        angle = 45
      when 2
        angle = -45

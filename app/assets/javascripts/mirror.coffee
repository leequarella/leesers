class @Mirror
  length: 40

  constructor: (@center_x, @center_y, @position) ->
    @calcPosition()

  calcPosition: ->
    @angle = @getAngle()
    @start_x = @center_x - ((@length/2) * Math.cos(@angle))
    @start_y = @center_y - ((@length/2) * Math.sin(@angle))
    @end_x = @start_x + (@length * Math.cos(@angle))
    @end_y = @start_y + (@length * Math.sin(@angle))
    console.log @angle

  draw: (canvas)->
    ctx = canvas.getContext("2d")
    ctx.beginPath()
    ctx.moveTo(@start_x, @start_y)
    ctx.lineTo(@end_x, @end_y)

    ctx.strokeStyle = '#0000ff'
    ctx.stroke()

  getAngle: ->
    switch @position
      when 1
        angle = 45
      when 2
        angle = -45
    return angle

  toggle: ->
    console.log "old position is #{@position}"
    switch @position
      when 1
        console.log "changing to 2"
        @position = 2
      when 2
        console.log "changing to 1"
        @position = 1

    @calcPosition()
    return @

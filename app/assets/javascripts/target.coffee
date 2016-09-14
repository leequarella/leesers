class @Target
  radius: 10

  constructor: (@player, @centerX, @centerY) ->

  draw: (context) ->
    context.beginPath()
    context.arc(@centerX, @centerY, @radius, 0, 2 * Math.PI, false)
    context.fillStyle = 'green'
    context.fill()
    context.stroke()

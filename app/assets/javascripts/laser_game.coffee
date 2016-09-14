class @LaserGame
  constructor: ->
    @canvas = document.getElementById("gameCanvas")
    @ctx = @canvas.getContext("2d")

  clearCanvas: ->
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)

  init: ->
    @initMirrors()
    @tick()

  initLasers: ->
    @lasers = [
      new Laser(0, 124, "East", "#325170")
      new Laser(0, 204, "East", "#461d42"),
      new Laser(0, 274, "East", "#cffb4c"),
      new Laser(@canvas.width, 125, "West", "#a00"),
      new Laser(@canvas.width, 200, "West", "#451407"),
      new Laser(@canvas.width, 275, "West", "#d0cb2f")]

  initMirrors: ->
    @mirrors = [
      new Mirror(100, 50, 1)
      new Mirror(200, 50, 1)
      new Mirror(300, 50, 1)
      new Mirror(400, 50, 1)

      new Mirror(100, 125, 1)
      new Mirror(200, 125, 1)
      new Mirror(300, 125, 1)
      new Mirror(400, 125, 1)

      new Mirror(100, 200, 1)
      new Mirror(200, 200, 1)
      new Mirror(300, 200, 1)
      new Mirror(400, 200, 1)

      new Mirror(100, 275, 1)
      new Mirror(200, 275, 1)
      new Mirror(300, 275, 1)
      new Mirror(400, 275, 1)

      new Mirror(100, 350, 1)
      new Mirror(200, 350, 1)
      new Mirror(300, 350, 1)
      new Mirror(400, 350, 1)
    ]

  tick: ->
    @clearCanvas()
    @initLasers()
    @reflect(laser) for laser in @lasers
    mirror.draw(@canvas) for mirror in @mirrors
    laser.draw(@canvas) for laser in @lasers

  findIntersection: (line_1, line_2) ->
    result = {
      x: null,
      y: null,
      on_line_1: false,
      on_line_2: false
    }

    denominator = ((line_2.end_y - line_2.start_y) * (line_1.end_x - line_1.start_x)) -
      ((line_2.end_x - line_2.start_x) * (line_1.end_y - line_1.start_y))

    return false if denominator == 0

    a = line_1.start_y - line_2.start_y
    b = line_1.start_x - line_2.start_x
    numerator1 = ((line_2.end_x - line_2.start_x) * a) - ((line_2.end_y - line_2.start_y) * b)
    numerator2 = ((line_1.end_x - line_1.start_x) * a) - ((line_1.end_y - line_1.start_y) * b)
    a = numerator1 / denominator
    b = numerator2 / denominator

    # if we cast these lines infinitely in both directions, they intersect here:
    result.x = line_1.start_x + (a * (line_1.end_x - line_1.start_x))
    result.y = line_1.start_y + (a * (line_1.end_y - line_1.start_y))
    # if line_1 is a segment and line_2 is infinite, they intersect if:
    if (a > 0 && a < 1)
        result.on_line_1 = true
    # if line_2 is a segment and line_1 is infinite, they intersect if:
    if (b > 0 && b < 1)
        result.on_line_2 = true
    # if line_1 and line_2 are segments, they intersect if both of the above are true

    return result

  findLaserMirrorIntersections: (laser) ->
    intersections = []
    for mirror, i in @mirrors
      intersection = @findIntersection(laser, mirror)
      intersection.mirror_id = i
      if intersection.on_line_1 && intersection.on_line_2
        intersections.push intersection

    return intersections

  reflect: (laser) ->
    laser.calcActualEnd(@findLaserMirrorIntersections(laser))
    if laser.hasTerminated(@canvas)
      console.log "Laser hit a wall."
    else
      intersected_mirror = @mirrors[laser.intersected_mirror_id]
      new_direction = laser.determineNewDirection(intersected_mirror)
      new_starting_position = laser.calcNextStartingPosition(intersected_mirror)
      new_laser = new Laser(new_starting_position.x, new_starting_position.y, new_direction, laser.color)
      @lasers.push new_laser
      @reflect(new_laser)

  toggleMirror: (mirror_id) ->
    @mirrors[mirror_id] = @mirrors[mirror_id].toggle()
    @tick()


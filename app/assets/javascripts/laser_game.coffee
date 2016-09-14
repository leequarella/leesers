class @LaserGame
  constructor: ->
    @canvas = document.getElementById("gameCanvas")
    @ctx = @canvas.getContext("2d")

  clearCanvas: ->
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)

  init: ->
    @initMirrors()
    @initTargets()
    @gameLoop = setInterval( (=>@tick()), 60)

  initTargets: ->
    @targets = [
      new Target(1, 100, 0)
      new Target(1, 200, 0)
      new Target(1, 300, 0)
      new Target(1, 400, 0)

      new Target(2, 100, @canvas.height)
      new Target(2, 200, @canvas.height)
      new Target(2, 300, @canvas.height)
      new Target(2, 400, @canvas.height)
    ]

  initLasers: ->
    six_lasers = [
      new Laser(0, 125, "East", "#325170")
      new Laser(0, 200, "East", "#461d42")
      new Laser(0, 275, "East", "#cffb4c")
      new Laser(@canvas.width, 125, "West", "#a00")
      new Laser(@canvas.width, 200, "West", "#451407")
      new Laser(@canvas.width, 275, "West", "#d0cb2f")
    ]

    two_lasers = [
      new Laser(0, 200, "East", "#f00")
      new Laser(@canvas.width, 200, "West", "#0f0")
    ]

    @lasers = two_lasers

  initMirrors: ->
    @mirrors = [
      new Mirror(100, 50, 2)
      new Mirror(200, 50, 1)
      new Mirror(300, 50, 2)
      new Mirror(400, 50, 1)

      new Mirror(100, 125, 1)
      new Mirror(200, 125, 2)
      new Mirror(300, 125, 1)
      new Mirror(400, 125, 1)

      new Mirror(100, 200, 2)
      new Mirror(200, 200, 1)
      new Mirror(300, 200, 2)
      new Mirror(400, 200, 2)

      new Mirror(100, 275, 2)
      new Mirror(200, 275, 1)
      new Mirror(300, 275, 2)
      new Mirror(400, 275, 1)

      new Mirror(100, 350, 1)
      new Mirror(200, 350, 2)
      new Mirror(300, 350, 1)
      new Mirror(400, 350, 2)
    ]

  tick: ->
    @clearCanvas()
    @initLasers()
    @reflect(laser) for laser in @lasers

    mirror.draw(@canvas) for mirror in @mirrors
    laser.draw(@canvas) for laser in @lasers
    target.draw(@ctx) for target in @targets


  findLaserMirrorIntersections: (laser) ->
    intersections = []
    for mirror, i in @mirrors
      intersection = LineIntersection.findIntersection(laser, mirror)
      intersection.mirror_id = i
      if intersection.on_line_1 && intersection.on_line_2
        intersections.push intersection

    return intersections

  reflect: (laser) ->
    laser.calcActualEnd(@findLaserMirrorIntersections(laser))
    unless laser.hasTerminated(@canvas)
      intersected_mirror = @mirrors[laser.intersected_mirror_id]
      new_direction = laser.determineNewDirection(intersected_mirror)
      new_starting_position = laser.calcNextStartingPosition(intersected_mirror)
      new_laser = new Laser(new_starting_position.x, new_starting_position.y, new_direction, laser.color)
      @lasers.push new_laser
      @reflect(new_laser)

  toggleMirror: (mirror_id) ->
    @mirrors[mirror_id] = @mirrors[mirror_id].toggle()


class @Laser
  constructor: (@start_x, @start_y, @direction, @color="#f00") ->
    @calcNaturalEnd()

  calcNaturalEnd: ->
    switch @direction
      when "North"
        @end_x = @start_x
        @end_y = 0
      when "East"
        @end_x = 100000
        @end_y = @start_y
      when "South"
        @end_x = @start_x
        @end_y = 100000
      when "West"
        @end_x = 0
        @end_y = @start_y

  calcActualEnd: (intersections)->
    for intersection in intersections
      switch @direction
        when "North"
          @end_x = intersection.x
          if intersection.y > @end_y
            @end_y = intersection.y
            @intersected_mirror_id = intersection.mirror_id
        when "East"
          if intersection.x < @end_x
            @end_x = intersection.x
            @intersected_mirror_id = intersection.mirror_id
          @end_y = intersection.y
        when "South"
          @end_x = intersection.x
          if intersection.y < @end_y
            @end_y = intersection.y
            @intersected_mirror_id = intersection.mirror_id
        when "West"
          if intersection.x > @end_x
            @end_x = intersection.x
            @intersected_mirror_id = intersection.mirror_id
          @end_y = intersection.y


  calcNextStartingPosition: (mirror) ->
    new_direction = @determineNewDirection(mirror)
    switch @direction
      when "North"
        if new_direction == "East"
          new_start_x = @end_x + 1
          new_start_y = @end_y - 1
        else
          new_start_x = @end_x - 1
          new_start_y = @end_y - 1
      when "South"
        if new_direction == "East"
          new_start_x = @end_x + 1
          new_start_y = @end_y + 1
        else
          new_start_x = @end_x - 1
          new_start_y = @end_y - 1
      when "West"
        if new_direction == "North"
          new_start_x = @end_x + 1
          new_start_y = @end_y + 1
        else
          new_start_x = @end_x + 1
          new_start_y = @end_y - 1
      when "East"
        if new_direction == "North"
          new_start_x = @end_x - 1
          new_start_y = @end_y - 1
        else
          new_start_x = @end_x - 1
          new_start_y = @end_y + 1

    return{x: new_start_x, y: new_start_y}

  hasTerminated: (canvas) ->
    (@end_x >= canvas.width) || (@end_x == 0) ||
    (@end_y >= canvas.height) || (@end_y == 0)

  determineNewDirection: (mirror) ->
    switch @direction
      when "North"
        if mirror.position == 1
          new_direction = "West"
        else
          new_direction = "East"
      when "South"
        if mirror.position == 1
          new_direction = "East"
        else
          new_direction = "West"
      when "East"
        if mirror.position == 1
          new_direction = "South"
        else
          new_direction = "North"
      when "West"
        if mirror.position == 1
          new_direction = "North"
        else
          new_direction = "South"

    return new_direction

  draw: (canvas) ->
    ctx = canvas.getContext("2d")
    ctx.beginPath()

    ctx.moveTo(@start_x, @start_y)
    ctx.lineTo(@end_x, @end_y)

    ctx.strokeStyle = @color
    ctx.stroke()

class LineIntersection
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

window.LineIntersection = new LineIntersection

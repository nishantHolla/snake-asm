## draw_grid
# PURPOSE: Draw a grind onto the raylib window
#
# INPUT: The function takes the following arguments:
#      - 1: Grid start vec2
#      - 2: Grid end vec2
#      - 3: Cell dimensions vec2
#      - 4: Grid Color
#
# OUTPUT: None
.extern draw_grid

## draw_food
# PURPOSE: Draw food onto the raylib window
#
# INPUT: The function takes the following arguments:
#      - 1: The vec2 of the food position to draw
#
# OUTPUT: None
.extern draw_food

## draw_snake
# PURPOSE: Draw the snake to raylib window
#
# INPUT: The function takes the following arguments:
#      - 1: The address of the buffer containing the coordinates of the snake body
#      - 2: The length of the snake
#
# OUTPUT: None
.extern draw_snake

## draw_score
# PURPOSE: Draw the given score to raylib wndow
#
# INPUT: The function takes the following arguments:
#      - 1: Score to print
#
# OUTPUT: None
.extern draw_score

# PURPOSE: Draw the restart info to raylib window
#
# INPUT: None
#
# OUTPUT: None
.extern draw_restart

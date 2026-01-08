## vec2_create
# PURPOSE: Create a 2d vector from integers
#
# INPUT: The function takes the following arguments:
#      - 1: x coordinate of the vector
#      - 2: y coordinate of the vector
#
# OUTPUT: The function stores the vector struct in %eax
#
# NOTE: A vec2 struct is a 4 byte object where the first two higher order bytes denote the x coordinate
#       and the last two lower oder bytes denote the y coordinate
#
#
#     -------------------------------------
#     | byte 3 | byte 2 | byte 1 | byte 0 |
#     -------------------------------------
#     |   x coordinate  |  y coordinate   |
#     -------------------------------------
#
.extern vec2_create

## vec2_load_x
# PURPOSE: Load x coordinate of a vec2 to eax
#
# INPUT: The function takes the following arguments:
#      - 1: The vector to load
#
# OUTPUT: The function stores the x coordinate in eax
.extern vec2_load_x

## vec2_load_y
# PURPOSE: Load y coordinate of a vec2 to eax
#
# INPUT: The function takes the following arguments:
#      - 1: The vector to load
#
# OUTPUT: The function stores the y coordinate in eax
.extern vec2_load_y

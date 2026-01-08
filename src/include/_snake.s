## snake_init
# PURPOSE: Initialize snake body upto a given length
#
# INPUT: The function takes the following arguments:
#      - 1: Starting address of the buffer to initialize
#      - 2: Size of the snake to initialize
#
# OUTPUT: None
.extern snake_init

## snake_move
# PURPOSE: Move the coordinates of a snake body in a given direction
#
# INPUT: The function takes the following inputs:
#      - 1: The address of the buffer containing the snake coordinates
#      - 2: The length of the snake
#      - 3: The direction in which to move the snake
#
# OUTPUT: None
.extern snake_move

## snake_check_movement
# PURPOSE: Check raylib inputs for snake movement
#
# INPUT: The function takes the following arguments:
#      - 1: Address of the direction variable that must be updated
#
# Output: None
.extern snake_check_movement

## snake_check_food
# PURPOSE: Check if snake has eaten food
#
# INPUT: The function takes the following arguments:
#      - 1: Address of Position of food
#      - 2: Address of Position of snake head
#      - 3: Address of the score variable
#      - 4: Address of snake length variable
#
# OUTPUT: None
.extern snake_check_food

## snake_check_health
# PURPOSE: Check if the snake is alive or not
#
# INPUT: The function takes the following arguments:
#      - 1: Address of the snake coordinates buffer
#      - 2: Length of the snake
#
# OUTPUT: %eax is set to 1 if the snake is alive, else, it is set to 0
.extern snake_check_health

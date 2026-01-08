.include "_vec2.s"
.include "_raylib.s"
.include "_constants.s"
.include "_food.s"
.include "_list.s"

## snake_init
# PURPOSE: Initialize snake body upto a given length
#
# INPUT: The function takes the following arguments:
#      - 1: Starting address of the buffer to initialize
#      - 2: Size of the snake to initialize
#
# OUTPUT: None
.section .data

.section .text
.global snake_init

.equ ST_BUFFER, 8
.equ ST_SIZE, 12
.equ ST_SNAKE, -4
.equ ST_COORD, -8

.type snake_init, @function
snake_init:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Starting position of snake head is col 16 and row 8
  movl $16, %eax
  movl $8, %ebx
  movl ST_BUFFER(%ebp), %ecx
  movl ST_SIZE(%ebp), %edi

snake_init_loop_head:
  ## Check if last snake body is initialized
  cmpl $0, %edi
  je snake_init_end

snake_init_loop_body:
  ## save address current snake cell and its x coordinate to local variables
  movl %ecx, ST_SNAKE(%ebp)
  movl %eax, ST_COORD(%ebp)

  ## create the vector for current cell
  subl $8, %esp
  pushl %ebx
  pushl %eax
  call vec2_create
  addl $16, %esp

  ## assign the created vector to the current snake cell
  movl ST_SNAKE(%ebp), %ecx
  movl %eax, (%ecx)
  movl ST_COORD(%ebp), %eax

snake_init_loop_tail:
  ## Move to next snake cell and decrement the current x coordinate
  decl %eax
  decl %edi
  addl $4, %ecx

  jmp snake_init_loop_head

snake_init_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


## snake_move
# PURPOSE: Move the coordinates of a snake body in a given direction
#
# INPUT: The function takes the following inputs:
#      - 1: The address of the buffer containing the snake coordinates
#      - 2: The length of the snake
#      - 3: The direction in which to move the snake
#
# OUTPUT: None
.section .data

.extern printf
print_fmt:
  .asciz "x = %d y = %d\n"

.section .text
.global snake_move

.equ ST_SNAKE_ADDRESS, 8
.equ ST_SNAKE_LENGTH, 12
.equ ST_DIRECTION, 16
.equ ST_X, -4
.equ ST_Y, -8

.type snake_move, @function
snake_move:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Get the address of the last snake cell
  movl ST_SNAKE_LENGTH(%ebp), %eax
  imull $4, %eax
  movl ST_SNAKE_ADDRESS(%ebp), %ebx
  addl %eax, %ebx
  subl $4, %ebx

  ## Initialize the countdown counter
  movl ST_SNAKE_LENGTH(%ebp), %edi

snake_move_loop_head:
  ## Check if snake head cell is reached, if so break out of the loop
  cmpl $1, %edi
  je snake_move_head

snake_move_loop_body:
  ## Assign the coordinate of the next snake cell in the list to the current snake cell
  movl %ebx, %eax
  subl $4, %eax
  movl (%eax), %ecx
  movl %ecx, (%ebx)

snake_move_loop_tail:
  ## Move to the next snake cell and decrement the counter
  decl %edi
  subl $4, %ebx

  jmp snake_move_loop_head

snake_move_head:
  ## Load the coordinates of the snake head
  subl $12, %esp
  pushl (%ebx)
  call vec2_load_x
  addl $16, %esp
  movl %eax, ST_X(%ebp)

  subl $12, %esp
  pushl (%ebx)
  call vec2_load_y
  addl $16, %esp
  movl %eax, ST_Y(%ebp)

  ## Load the current direction of the snake
  movl ST_DIRECTION(%ebp), %eax

  ## Check the current direction of the snake
  cmpl $NORTH, %eax
  je snake_move_head_north

  cmpl $EAST, %eax
  je snake_move_head_east

  cmpl $SOUTH, %eax
  je snake_move_head_south

  cmpl $WEST, %eax
  je snake_move_head_west

snake_move_head_north:
  ## X stays same, decrement Y
  movl ST_Y(%ebp), %eax
  decl %eax

  ## Create and assign the new vector
  subl $8, %esp
  pushl %eax
  pushl ST_X(%ebp)
  call vec2_create
  addl $16, %esp
  movl %eax, (%ebx)

  jmp snake_move_end

snake_move_head_east:
  ## Y stays same, increment X
  movl ST_X(%ebp), %eax
  incl %eax

  ## Create and assign the new vector
  subl $8, %esp
  pushl ST_Y(%ebp)
  pushl %eax
  call vec2_create
  addl $16, %esp
  movl %eax, (%ebx)

  jmp snake_move_end

snake_move_head_south:
  ## X stays same, increment Y
  movl ST_Y(%ebp), %eax
  incl %eax

  ## Create and assign the new vector
  subl $8, %esp
  pushl %eax
  pushl ST_X(%ebp)
  call vec2_create
  addl $16, %esp
  movl %eax, (%ebx)

  jmp snake_move_end

snake_move_head_west:
  ## Y stays same, decrement X
  movl ST_X(%ebp), %eax
  decl %eax

  ## Create and assign the new vector
  subl $8, %esp
  pushl ST_Y(%ebp)
  pushl %eax
  call vec2_create
  addl $16, %esp
  movl %eax, (%ebx)

  jmp snake_move_end

snake_move_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


## snake_check_movement
# PURPOSE: Check raylib inputs for snake movement
#
# INPUT: The function takes the following arguments:
#      - 1: Address of the direction variable that must be updated
#
# Output: None
.section .data

.equ ST_DIRECTION_ADDRESS, 8
.equ ST_X, -4
.equ ST_Y, -8

.section .text
.global snake_check_movement

.type snake_check_movement, @function
snake_check_movement:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Check the current key pressed
  subl $12, %esp
  pushl $KEY_W
  call IsKeyDown
  addl $16, %esp

  cmp $TRUE, %al
  je snake_check_movement_move_north

  subl $12, %esp
  pushl $KEY_D
  call IsKeyDown
  addl $16, %esp

  cmp $TRUE, %al
  je snake_check_movement_move_east

  subl $12, %esp
  pushl $KEY_S
  call IsKeyDown
  addl $16, %esp

  cmp $TRUE, %al
  je snake_check_movement_move_south

  subl $12, %esp
  pushl $KEY_A
  call IsKeyDown
  addl $16, %esp

  cmp $TRUE, %al
  je snake_check_movement_move_west

  jmp snake_check_movement_end

snake_check_movement_move_north:
  ## If current direction is not south, set it to north
  movl ST_DIRECTION_ADDRESS(%ebp), %ebx
  movl (%ebx), %eax

  cmpl $SOUTH, %eax
  je snake_move_end

  movl $NORTH, (%ebx)
  jmp snake_move_end

snake_check_movement_move_east:
  ## If current direction is not west, set it to east
  movl ST_DIRECTION_ADDRESS(%ebp), %ebx
  movl (%ebx), %eax

  cmpl $WEST, %eax
  je snake_move_end

  movl $EAST, (%ebx)
  jmp snake_move_end

snake_check_movement_move_south:
  ## If current direction is not north, set it to south
  movl ST_DIRECTION_ADDRESS(%ebp), %ebx
  movl (%ebx), %eax

  cmpl $NORTH, %eax
  je snake_move_end

  movl $SOUTH, (%ebx)
  jmp snake_move_end

snake_check_movement_move_west:
  ## If current direction is not east, set it to west
  movl ST_DIRECTION_ADDRESS(%ebp), %ebx
  movl (%ebx), %eax

  cmpl $EAST, %eax
  je snake_move_end

  movl $WEST, (%ebx)
  jmp snake_move_end

snake_check_movement_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


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
.section .data

.equ ST_FOOD, 8
.equ ST_SNAKE, 12
.equ ST_SCORE_ADDRESS, 16
.equ ST_SNAKE_LENGTH, 20

.section .text
.global snake_check_food

.type snake_check_food, @function
snake_check_food:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  movl ST_FOOD(%ebp), %eax
  movl (%eax), %ebx

  movl ST_SNAKE(%ebp), %eax
  movl (%eax), %ecx

  cmpl %ebx, %ecx
  jne snake_check_food_end

  movl ST_SCORE_ADDRESS(%ebp), %ecx
  incl (%ecx)

  movl ST_SNAKE_LENGTH(%ebp), %ecx
  incl (%ecx)

  subl $12, %esp
  pushl ST_FOOD(%ebp)
  call food_generate
  addl $16, %esp

snake_check_food_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


## snake_check_health
# PURPOSE: Check if the snake is alive or not
#
# INPUT: The function takes the following arguments:
#      - 1: Address of the snake coordinates buffer
#      - 2: Length of the snake
#
# OUTPUT: %eax is set to 1 if the snake is alive, else, it is set to 0
.section .data

.equ ST_SNAKE_ADDRESS, 8
.equ ST_SNAKE_LENGTH, 12

.section .text
.global snake_check_health

.type snake_check_health, @function
snake_check_health:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  movl ST_SNAKE_ADDRESS(%ebp), %eax
  movl (%eax), %ecx
  addl $4, %eax

  movl ST_SNAKE_LENGTH(%ebp), %ebx
  decl %ebx

  ## Check if head is colliding with its body
  subl $4, %esp
  pushl %ebx
  pushl %eax
  pushl %ecx
  call list_contains
  addl $16, %esp

  cmpl $1, %eax
  je snake_check_health_bad

  ## Load the coordinates of the snake head
  movl ST_SNAKE_ADDRESS(%ebp), %ebx

  subl $12, %esp
  pushl (%ebx)
  call vec2_load_x
  addl $16, %esp
  movl %eax, ST_X(%ebp)

  subl $12, %esp
  pushl (%ebx)
  call vec2_load_y
  addl $16, %esp
  movl %eax, ST_Y(%ebp)

  ## Check if x is out of bound
  movl ST_X(%ebp), %eax
  cmpl $0, %eax
  jl snake_check_health_bad

  cmpl $COL_COUNT, %eax
  jge snake_check_health_bad

  ## Check if y is out of bound
  movl ST_Y(%ebp), %eax
  cmpl $0, %eax
  jl snake_check_health_bad

  cmpl $ROW_COUNT, %eax
  jge snake_check_health_bad

  movl $1, %eax

snake_check_health_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

snake_check_health_bad:
  movl $0, %eax
  jmp snake_check_health_end

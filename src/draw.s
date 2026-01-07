.include "_raylib.s"
.include "_vec2.s"
.include "_constants.s"

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
.section .data

start_x:
  .long 0

start_y:
  .long 0

end_x:
  .long 0

end_y:
  .long 0

cell_x:
  .long 0

cell_y:
  .long 0

.equ ST_GRID_START_VEC2, 8
.equ ST_GRID_END_VEC2, 12
.equ ST_CELL_DIM, 16
.equ ST_GRID_COLOR, 20

.section .text
.global draw_grid

.type draw_grid, @function
draw_grid:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Load the vectors
  subl $12, %esp
  pushl ST_GRID_START_VEC2(%ebp)
  call vec2_load_x
  addl $16, %esp
  movl %eax, start_x

  subl $12, %esp
  pushl ST_GRID_START_VEC2(%ebp)
  call vec2_load_y
  addl $16, %esp
  movl %eax, start_y

  subl $12, %esp
  pushl ST_GRID_END_VEC2(%ebp)
  call vec2_load_x
  addl $16, %esp
  movl %eax, end_x

  subl $12, %esp
  pushl ST_GRID_END_VEC2(%ebp)
  call vec2_load_y
  addl $16, %esp
  movl %eax, end_y

  subl $12, %esp
  pushl ST_CELL_DIM(%ebp)
  call vec2_load_x
  addl $16, %esp
  movl %eax, cell_x

  subl $12, %esp
  pushl ST_CELL_DIM(%ebp)
  call vec2_load_y
  addl $16, %esp
  movl %eax, cell_y

draw_grid_row:
  ## Initialize for row drawing
  movl start_y, %edi
  movl end_y, %ebx

draw_grid_row_loop_head:
  ## Check if end is reached
  cmpl %ebx, %edi
  jge draw_grid_col

draw_grid_row_loop_body:
  ## Draw the row
  subl $12, %esp
  pushl ST_GRID_COLOR(%ebp)
  pushl %edi
  pushl end_x
  pushl %edi
  pushl start_x
  call DrawLine
  addl $32, %esp

draw_grid_row_loop_foot:
  ## Increment the row number and continue
  addl cell_y, %edi
  jmp draw_grid_row_loop_head

draw_grid_col:
  ## Initialize for column drawing
  movl start_x, %edi
  movl end_x, %ebx

draw_grid_col_loop_head:
  ## Check if end is reached
  cmpl %ebx, %edi
  jge draw_grid_end

draw_grid_col_loop_body:
  ## Draw the column
  subl $12, %esp
  pushl ST_GRID_COLOR(%ebp)
  pushl end_y
  pushl %edi
  pushl start_y
  pushl %edi
  call DrawLine
  addl $32, %esp

draw_grid_col_loop_foot:
  ## Increment the column number and continue
  addl cell_x, %edi
  jmp draw_grid_col_loop_head

draw_grid_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


## draw_food
# PURPOSE: Draw food onto the raylib window
#
# INPUT: The function takes the following arguments:
#      - 1: The vec2 of the food position to draw
#
# OUTPUT: None
.section .data

.equ ST_FOOD_VEC, 8
.equ ST_FOOD_X, -4
.equ ST_FOOD_Y, -8

.section .text
.global draw_food

.type draw_food, @function
draw_food:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Load the food vector
  subl $12, %esp
  pushl ST_FOOD_VEC(%ebp)
  call vec2_load_x
  addl $16, %esp
  imull $CELL_X, %eax
  movl %eax, ST_FOOD_X(%ebp)

  subl $12, %esp
  pushl ST_FOOD_VEC(%ebp)
  call vec2_load_y
  addl $16, %esp
  imull $CELL_Y, %eax
  addl $HEADER_HEIGHT, %eax
  movl %eax, ST_FOOD_Y(%ebp)

  ## Draw the food
  pushl $FOOD_COLOR
  pushl $CELL_Y
  pushl $CELL_X
  pushl ST_FOOD_Y(%ebp)
  pushl ST_FOOD_X(%ebp)
  call DrawRectangle
  addl $16, %esp

draw_food_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


## draw_snake
# PURPOSE: Draw the snake to raylib window
#
# INPUT: The function takes the following arguments:
#      - 1: The address of the buffer containing the coordinates of the snake body
#      - 2: The length of the snake
#
# OUTPUT: None
.section .data

.equ ST_SNAKE_BUFFER, 8
.equ ST_SNAKE_LENGTH, 12
.equ ST_SNAKE_X, -4
.equ ST_SNAKE_Y, -8

.section .text
.global draw_snake

.type draw_snake, @function
draw_snake:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  movl ST_SNAKE_BUFFER(%ebp), %ebx
  movl ST_SNAKE_LENGTH(%ebp), %edi

draw_snake_loop_head:
  cmpl $0, %edi
  je draw_snake_end

draw_snake_loop_body:
  subl $12, %esp
  pushl (%ebx)
  call vec2_load_x
  addl $16, %esp
  imull $CELL_X, %eax
  movl %eax, ST_SNAKE_X(%ebp)

  subl $12, %esp
  pushl (%ebx)
  call vec2_load_y
  addl $16, %esp
  imull $CELL_Y, %eax
  addl $HEADER_HEIGHT, %eax
  movl %eax, ST_SNAKE_Y(%ebp)

  pushl $SNAKE_COLOR
  pushl $CELL_Y
  pushl $CELL_X
  pushl ST_SNAKE_Y(%ebp)
  pushl ST_SNAKE_X(%ebp)
  call DrawRectangle
  addl $16, %esp

draw_snake_loop_foot:
  addl $4, %ebx
  decl %edi
  jmp draw_snake_loop_head

draw_snake_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

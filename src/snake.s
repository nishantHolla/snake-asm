.include "_vec2.s"
.include "_constants.s"

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

  movl $16, %eax
  movl $8, %ebx
  movl ST_BUFFER(%ebp), %ecx
  movl ST_SIZE(%ebp), %edi

snake_init_loop_head:
  cmpl $0, %edi
  je snake_init_end

snake_init_loop_body:
  movl %ecx, ST_SNAKE(%ebp)
  movl %eax, ST_COORD(%ebp)

  subl $8, %esp
  pushl %ebx
  pushl %eax
  call vec2_create
  addl $16, %esp

  movl ST_SNAKE(%ebp), %ecx
  movl %eax, (%ecx)
  movl ST_COORD(%ebp), %eax

snake_init_loop_tail:
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

  movl ST_SNAKE_LENGTH(%ebp), %eax
  imull $4, %eax
  movl ST_SNAKE_ADDRESS(%ebp), %ebx
  addl %eax, %ebx
  subl $4, %ebx

  movl ST_SNAKE_LENGTH(%ebp), %edi

snake_move_loop_head:
  cmpl $1, %edi
  je snake_move_head

snake_move_loop_body:
  movl %ebx, %eax
  subl $4, %eax
  movl (%eax), %ecx
  movl %ecx, (%ebx)

snake_move_loop_tail:
  decl %edi
  subl $4, %ebx
  jmp snake_move_loop_head

snake_move_head:
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

  movl ST_DIRECTION(%ebp), %eax

  cmpl $NORTH, %eax
  je snake_move_head_north

  cmpl $EAST, %eax
  je snake_move_head_east

  cmpl $SOUTH, %eax
  je snake_move_head_south

  cmpl $WEST, %eax
  je snake_move_head_west

snake_move_head_north:
  movl ST_Y(%ebp), %eax
  decl %eax

  subl $8, %esp
  pushl %eax
  pushl ST_X(%ebp)
  call vec2_create
  addl $16, %esp
  movl %eax, (%ebx)

  jmp snake_move_end

snake_move_head_east:
  movl ST_X(%ebp), %eax
  incl %eax

  subl $8, %esp
  pushl ST_Y(%ebp)
  pushl %eax
  call vec2_create
  addl $16, %esp
  movl %eax, (%ebx)

  jmp snake_move_end

snake_move_head_south:
  movl ST_Y(%ebp), %eax
  incl %eax

  subl $8, %esp
  pushl %eax
  pushl ST_X(%ebp)
  call vec2_create
  addl $16, %esp
  movl %eax, (%ebx)

  jmp snake_move_end

snake_move_head_west:
  movl ST_X(%ebp), %eax
  decl %eax

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

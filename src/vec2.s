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
.section .data

.equ ST_X_COORD, 8
.equ ST_Y_COORD, 12

.section .text
.global vec2_create

.type vec2_create, @function
vec2_create:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Load x -> shift by 2 bytes -> load y
  movl ST_X_COORD(%ebp), %eax
  shll $16, %eax
  mov ST_Y_COORD(%ebp), %ax

vec2_create_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


# PURPOSE: Load x coordinate of a vec2 to eax
#
# INPUT: The function takes the following arguments:
#      - 1: The vector to load
#
# OUTPUT: The function stores the x coordinate in eax
.section .data

.equ ST_VEC, 8

.section .text
.global vec2_load_x

.type vec2_load_x, @function
vec2_load_x:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Load the vector and shift right to remove the last two lower order bytes
  movl ST_VEC(%ebp), %eax
  shrl $16, %eax

vec2_load_x_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

# PURPOSE: Load y coordinate of a vec2 to eax
#
# INPUT: The function takes the following arguments:
#      - 1: The vector to load
#
# OUTPUT: The function stores the y coordinate in eax
.section .data

.equ ST_VEC, 8

.section .text
.global vec2_load_y

.type vec2_load_y, @function
vec2_load_y:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  # Load the vector and and with 0xffff to remove first two higher order bytes
  movl ST_VEC(%ebp), %eax
  andl $0xffff, %eax

vec2_load_y_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

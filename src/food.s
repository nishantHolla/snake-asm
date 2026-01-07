.include "_constants.s"
.include "_vec2.s"
.extern rand
.extern printf

# PURPOSE: Geneate a new random vec2 position for the foot and store it in given location
#
# INPUT: The function take the following input
#      - 1: The location to store the vector in
#
# OUTPUT: None
.section .data

log_food_pos_fmt:
  .asciz "[INFO]: Generated food at row %d and col %d\n"

.equ ST_VEC_ADDRESS, 8
.equ ST_X, -4
.equ ST_Y, -8

.section .text
.global food_generate

.type food_generate, @function
food_generate:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  call rand
  movl $COL_COUNT, %ebx
  xorl %edx, %edx
  divl %ebx
  movl %edx, ST_X(%ebp)

  call rand
  movl $ROW_COUNT, %ebx
  xorl %edx, %edx
  divl %ebx
  movl %edx, ST_Y(%ebp)

  subl $8, %esp
  pushl ST_Y(%ebp)
  pushl ST_X(%ebp)
  call vec2_create
  addl $16, %esp

  movl %eax, %ebx

  subl $4, %esp
  pushl ST_Y(%ebp)
  pushl ST_X(%ebp)
  pushl $log_food_pos_fmt
  call printf
  addl $16, %esp

  movl ST_VEC_ADDRESS(%ebp), %ecx
  movl %ebx, (%ecx)

food_generate_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

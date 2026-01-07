.include "_vec2.s"

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
  movl $10, %ebx
  movl ST_BUFFER(%ebp), %ecx
  movl ST_SIZE(%ebp), %edi

snake_init_loop_head:
  cmpl $0, %edi
  je snake_init_end

snake_init_loop_body:
  pushl %eax
  pushl %ecx
  pushl %ebx
  pushl %eax
  call vec2_create
  addl $8, %esp
  popl %ecx
  movl %eax, (%ecx)
  popl %eax

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

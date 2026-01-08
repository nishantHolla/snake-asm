## list_contains
# PURPOSE: Check if an element is present in a given list
#
# INPUT: The function takes the following arguments:
#      - 1: Element to check for
#      - 2: Address of the buffer
#      - 3: Size of the buffer
#
# OUTPUT: %eax is set to 1 if the element is found in the list, else, it is set to 0
.section .data

.equ ST_ELEMENT, 8
.equ ST_BUFFER, 12
.equ ST_SIZE, 16

.section .text
.global list_contains

.type list_contains, @function
list_contains:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Initialize the registers with the function arguments
  movl ST_SIZE(%ebp), %edi
  movl ST_BUFFER(%ebp), %eax
  movl ST_ELEMENT(%ebp), %ebx

list_contains_loop_head:
  ## Check if last element is checked, if so, then the element is not found
  cmpl $0, %edi
  je list_contains_not_found

list_contains_loop_body:
  ## Check if the current list element is the element we are looking for, if so, then the element is found
  cmpl (%eax), %ebx
  je list_contains_found

list_contains_loop_foot:
  ## Move to next element and repeat
  addl $4, %eax
  decl %edi;

  jmp list_contains_loop_head

list_contains_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

list_contains_found:
  ## We found the element
  movl $1, %eax
  jmp list_contains_end

list_contains_not_found:
  ## We did not find the element
  movl $0, %eax
  jmp list_contains_end

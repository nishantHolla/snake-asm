.include "_constants.s"
.include "_raylib.s"
.include "_window.s"

.section .data

.section .text
.global main

.type main, @function
main:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Raylib window config flags
  subl $12, %esp
  pushl $FLAG_FULLSCREEN_MODE
  call SetConfigFlags
  addl $16, %esp

  ## Create raylib window
  subl $4, %esp
  pushl $window_title
  pushl window_height
  pushl window_width
  call InitWindow
  addl $16, %esp

game_loop_head:
  ## Check if window should close, if so, break the loop
  call WindowShouldClose
  cmp $TRUE, %al
  je end

game_loop_body:

  call BeginDrawing

  subl $12, %esp
  pushl $WINDOW_BG
  call ClearBackground
  addl $16, %esp

  call EndDrawing

game_loop_tail:
  jmp game_loop_head

end:
  ## Destroy raylib window and set return code
  call CloseWindow
  movl $0, %eax

  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

.include "_constants.s"
.include "_raylib.s"
.include "_vec2.s"
.include "_food.s"
.include "_snake.s"

.extern srand
.extern time
.extern printf

.section .data

grid_start_vec:
  .long 0

grid_end_vec:
  .long 0

grid_cell_size:
  .long 0

window_title:
  .asciz "snake game"

window_width:
  .long WINDOW_WIDTH

window_height:
  .long WINDOW_HEIGHT

food_vec:
  .long 0

snake_length:
  .long 0

snake_direction:
  .long EAST

snake_is_alive:
  .long TRUE

score:
  .long 0

.section .bss

.lcomm snake_body, 500

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

  ## Initialize random
  subl $12, %esp
  pushl $0
  call time
  addl $16, %esp

  subl $12, %esp
  pushl %eax
  call srand
  addl $16, %esp

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

  ## Set target fps
  subl $12, %esp
  pushl $TARGET_FPS
  call SetTargetFPS
  addl $16, %esp

  ## Initialize grid
  subl $8, %esp
  pushl $HEADER_HEIGHT
  pushl $0
  call vec2_create
  addl $16, %esp
  movl %eax, grid_start_vec

  subl $8, %esp
  pushl window_height
  pushl window_width
  call vec2_create
  addl $16, %esp
  movl %eax, grid_end_vec

  subl $8, %esp
  pushl $CELL_Y
  pushl $CELL_X
  call vec2_create
  addl $16, %esp
  movl %eax, grid_cell_size

  ## Initialize food
  subl $4, %esp
  pushl snake_length
  pushl $snake_body
  pushl $food_vec
  call food_generate
  addl $16, %esp

start_game:
  ## Initialize snake status
  movl $TRUE, snake_is_alive
  movl $0, score
  movl $INITIAL_SNAKE_LENGTH, snake_length
  movl $EAST, snake_direction

  ## Initialize snake
  subl $8, %esp
  pushl snake_length
  pushl $snake_body
  call snake_init
  addl $16, %esp

game_loop_head:
  ## Check if window should close, if so, break the loop
  call WindowShouldClose
  cmp $TRUE, %al
  je end

  cmpl $FALSE, snake_is_alive
  je game_loop_check_restart

  subl $12, %esp
  pushl $snake_direction
  call snake_check_movement
  addl $16, %esp

game_loop_body:
  subl $8, %esp
  pushl snake_length
  pushl $snake_body
  call snake_check_health
  addl $16, %esp
  movl %eax, snake_is_alive

  cmpl $FALSE, snake_is_alive
  je game_loop_check_restart

  pushl $snake_length
  pushl $score
  pushl $snake_body
  pushl $food_vec
  call snake_check_food
  addl $16, %esp

  ## Move the snake
  subl $4, %esp
  pushl snake_direction
  pushl snake_length
  pushl $snake_body
  call snake_move
  addl $16, %esp

  jmp game_loop_draw

game_loop_check_restart:
  subl $12, %esp
  pushl $KEY_R
  call IsKeyDown
  addl $16, %esp

  cmp $TRUE, %al
  je start_game

game_loop_draw:
  call BeginDrawing

  ## Clear the window
  subl $12, %esp
  pushl $WINDOW_BG
  call ClearBackground
  addl $16, %esp

  ## Draw the grid
  pushl $WINDOW_FG
  pushl grid_cell_size
  pushl grid_end_vec
  pushl grid_start_vec
  call draw_grid
  addl $16, %esp

  ## Draw the snake
  subl $8, %esp
  pushl snake_length
  pushl $snake_body
  call draw_snake
  addl $16, %esp

  ## Draw the food
  subl $12, %esp
  pushl food_vec
  call draw_food
  addl $16, %esp

  ## Draw the score
  subl $12, %esp
  pushl score
  call draw_score
  addl $16, %esp

  ## Draw restart instruction if snake is dead
  cmpl $FALSE, snake_is_alive
  jne skip_restart_inst
  call draw_restart

skip_restart_inst:


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

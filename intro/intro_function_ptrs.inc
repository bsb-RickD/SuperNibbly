.ifndef INTRO_FUNCTION_PTRS_INC
INTRO_FUNCTION_PTRS_INC = 1

INTRO_FPB = *                             ; intro function pointer base
INTRO_FPI = ((INTRO_FPB-function_ptrs)/8)
   .word 0,0                              ; 0 - nullptr
   no_commands_to_add
ptr_check_return_to_basic:                ; 1 - check for exit
   .word check_return_to_basic, 0         
   no_commands_to_add

ptr_unpack_intro:                         ; 2 - unpack screen data
   .word fill_screen, 0         
   commands_to_add INTRO_FPB,3,6,7,8      ; after unpacking, wait for fadeout and initialize the random ranges in the meantime

ptr_wait_for_fade_out:                    ; 3 - wait for fading out the palette
   .word fade_out_and_switch_to_tiled_mode, palfade_out         
   commands_to_add INTRO_FPB,4,5,14,9     ; after fading out, fade back in and, start smoke, generate pause

ptr_fade_in:                              ; 4 - fade pal in
   .word fade_intro_in, palfade_in
   commands_to_add INTRO_FPB, 15

ptr_animate_smoke:                        ; 5 - smoke animation
   .word loop_sprite, animated_smoke
   no_commands_to_add

                                          ; 6 - init fish pause random range
   .word worker_initialize_random_range, fish_pause_range   
   commands_to_add INTRO_FPB,7            ; get the random pause and kick it off

                                          ; 7 - init fish x random range
   .word worker_initialize_random_range, fish_x_range
   no_commands_to_add

                                          ; 8 - init fish y random range
   .word worker_initialize_random_range, fish_y_range   
   no_commands_to_add

                                          ; 9 create random pause for fish
   .word worker_generate_random, fish_generate_pause
   commands_to_add INTRO_FPB,10,11,12

                                          ; 10 start fish pause
   .word worker_decrement_16, fish_pause_counter
   commands_to_add INTRO_FPB,13

                                          ; 11 create random x for fish
   .word worker_generate_random, fish_generate_x
   no_commands_to_add

                                          ; 12 create random y for fish
   .word worker_generate_random, fish_generate_y
   no_commands_to_add

                                          ; 13 let the fish jump - this implicitly turns the sprite on
   .word animate_sprite, jumping_fish
   commands_to_add INTRO_FPB,14,9         ; hide fish, generate new pause

                                          ; 14 turn the fish off
   .word switch_sprite_off, jumping_fish
   no_commands_to_add                     

                                          ; 15 show nibbly
   .word drop_n, 0
   no_commands_to_add
.endif
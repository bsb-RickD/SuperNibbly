.ifndef INTRO_FUNCTION_PTRS_INC
INTRO_FUNCTION_PTRS_INC = 1

.define intro_fp_index(ptr) (ptr-function_ptrs)/8

INTRO_FPB = *                             ; intro function pointer base
INTRO_FPI = intro_fp_index INTRO_FPB
   .word 0,0                              ; 0 - nullptr
   no_commands_to_add

ptr_check_return_to_basic:                ; 1 - check for exit
   .word check_return_to_basic, 0         
   no_commands_to_add

ptr_intro_startup:                        ; 2 - fade and wait for unpacking
   .word worker_sequence, seq_wait_for_unpack         
   commands_to_add INTRO_FPB,3            ; now fade in, and kick off others

                                          ; 3 - fade pal in
   .word worker_palette_fade, intro_fade_in
   no_commands_to_add
   ;commands_to_add INTRO_FPB, 10         ; start dropping nibbly

ptr_intro_decompress_base_data:           ; 4 - decompress base data
   .word worker_decompress_to_vram, intro_decompress_base_data
   commands_to_add INTRO_FPB,5            ; signal that decompression is done

                                          ; 5 - signal decompression is done
   .word worker_signal_semaphore, sem_unpack
   no_commands_to_add                     ; 


/*
ptr_unpack_intro:                         ; 2 - unpack screen data
   .word fill_screen, 0         
   commands_to_add INTRO_FPB,3,6,7,8      ; after unpacking, wait for fadeout and initialize the random ranges in the meantime

ptr_wait_for_fade_out:                    ; 3 - wait for fading out the palette
   .word all_blue_and_switch_to_tiled_mode, palfade_out         
   commands_to_add INTRO_FPB,4,5,9        ; after fading out, fade back in and, start smoke, start fish

ptr_fade_in:                              ; 4 - fade pal in
   .word fade_intro_in, palfade_in
   commands_to_add INTRO_FPB, 10          ; start dropping nibbly

ptr_animate_smoke:                        ; 5 - smoke animation
   .word loop_sprite, animated_smoke
   no_commands_to_add

                                          ; 6 - init fish pause random range
   .word worker_initialize_random_range, fish_pause_range   
   no_commands_to_add                    

                                          ; 7 - init fish x random range
   .word worker_initialize_random_range, fish_x_range
   no_commands_to_add

                                          ; 8 - init fish y random range
   .word worker_initialize_random_range, fish_y_range   
   no_commands_to_add

                                          ; 9 - the fish sequence
   .word worker_sequence, seq_jumping_fish   
   commands_to_add INTRO_FPB, 9           ; the fish loops, jumping randomly for ever


                                          ; 10 - the dropping nibbly sequence
   .word worker_sequence, seq_dropping_nibbly
   no_commands_to_add
*/   


; the start sequence:
;
; fade out, switch to tile mode, wait for unpacking to be done
;
seq_wait_for_unpack:
   make_sequence                                      \
      worker_palette_fade, text_fade_out,             \
      worker_wait_semaphore, sem_unpack,              \         
      all_blue_and_switch_to_tiled_mode, 0


; the fish jump sequence: 
;    first generate the random pause and pos
;    then wait for pause to pass
;    then the fish jumps
;    then the fish gets turned off
;
;    (now we can repeat) 
seq_jumping_fish:
   make_sequence                                      \
      switch_sprite_off, jumping_fish,                \
      worker_generate_random, fish_generate_pause,    \ 
      worker_generate_random, fish_generate_x,        \
      worker_generate_random, fish_generate_y,        \
      worker_decrement_16, fish_pause_counter,        \
      animate_sprite, jumping_fish,                   \
      switch_sprite_off, jumping_fish

; the nibbly drop sequence:
;
; self explaining, drop one after the other
;
seq_dropping_nibbly:
   make_sequence                                      \
      drop_letter, dropping_n,                        \
      drop_letter, dropping_i,                        \
      drop_letter, dropping_b1,                       \
      drop_letter, dropping_b2,                       \
      drop_letter, dropping_l,                        \
      drop_letter, dropping_y                         \





.endif
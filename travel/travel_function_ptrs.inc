.ifndef TRAVEL_FUNCTION_PTRS_INC
TRAVEL_FUNCTION_PTRS_INC = 1

TRAVEL_FPB = *                            ; intro function pointer base
TRAVEL_FPI = ((TRAVEL_FPB-function_ptrs)/8)

   .word travel_left, mountain_bg_0       ; 0 
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_bg_1       ; 1
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_bg_2       ; 2
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_bg_3       ; 3
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_0       ; 4 
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_1       ; 5
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_2       ; 6
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_3       ; 7
   no_commands_to_add                     ; nothing, mountains just travel on and on..

.endif
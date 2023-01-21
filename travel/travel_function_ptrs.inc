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

   .word travel_left, tree_bg_0           ; 8
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_1           ; 9
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_2           ; 10
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_3           ; 11
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_4           ; 12
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_5           ; 13
   no_commands_to_add                     ; 

   .word travel_left, house_bg_0          ; 14
   no_commands_to_add                     ; 

   .word travel_left, house_bg_1          ; 15
   no_commands_to_add                     ; 

   .word travel_left, house_fg_0          ; 16
   no_commands_to_add                     ; 

   .word travel_left, house_fg_1          ; 17
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_0           ; 18
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_1           ; 19
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_2           ; 20
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_3           ; 21
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_4           ; 22
   no_commands_to_add                     ; 

.endif
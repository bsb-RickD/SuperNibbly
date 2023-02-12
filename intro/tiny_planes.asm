; tiny plane movement table for plane 1
; .word x,y                             ; offset 0, startpos
; .byte count                           ; offset 4 - count
; .byte sprite#                         ; offset 5 - sprite number
; .word current                         ; offset 6 - pointer to current data
; .byte x-add, y-add, sprite-frame      ; offset 8 plus - the actual data
;    (x and y add are signed bytes)
plane_movement_1:
        .word 0,80                      ; x,y
        .byte 79                        ; count
        .byte 0                         ; sprite #
        .word *+2                       ; data ptr
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,255,1
        .byte 2,254,2
        .byte 1,254,3
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 255,254,5
        .byte 254,254,6
        .byte 254,255,7
        .byte 254,255,7
        .byte 254,255,7
        .byte 254,255,7
        .byte 254,255,7
        .byte 254,255,7
        .byte 254,254,6
        .byte 255,254,5
        .byte 0,254,4
        .byte 0,254,4
        .byte 1,254,3
        .byte 1,254,3
        .byte 2,254,2
        .byte 2,254,2
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,254,2
        .byte 2,254,2
        .byte 2,254,2
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,251,0

; tiny plane movement table for plane 2
; .word x,y                             ; offset 0, startpos
; .byte count                           ; offset 4 - count
; .byte sprite#                         ; offset 5 - sprite number
; .word current                         ; offset 6 - pointer to current data
; .byte x-add, y-add, sprite-frame      ; offset 8 plus - the actual data
;    (x and y add are signed bytes)
plane_movement_2:
        .word 78,8                      ; x,y
        .byte 137                       ; count
        .byte 1                         ; sprite #
        .word *+2                       ; data ptr
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,0,0
        .byte 0,3,12
        .byte 0,3,12
        .byte 0,3,12
        .byte 0,3,12
        .byte 0,3,12
        .byte 0,3,12
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 1,3,13
        .byte 2,2,14
        .byte 3,1,15
        .byte 2,255,0
        .byte 2,255,1
        .byte 1,254,2
        .byte 0,254,3
        .byte 255,254,4
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 254,254,6
        .byte 254,255,7
        .byte 254,0,8
        .byte 254,1,9
        .byte 254,2,10
        .byte 255,3,11
        .byte 0,3,12
        .byte 1,3,13
        .byte 2,3,14
        .byte 3,2,15
        .byte 3,2,15
        .byte 3,1,15
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,0,0
        .byte 3,1,15
        .byte 2,2,14
        .byte 1,2,13
        .byte 0,3,12
        .byte 255,2,11
        .byte 254,1,10
        .byte 254,0,8
        .byte 254,255,7
        .byte 254,254,6
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 0,254,4
        .byte 1,254,3
        .byte 2,2,2
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,0,0
        .byte 2,1,15
        .byte 2,2,14
        .byte 2,3,13
        .byte 0,3,12
        .byte 0,3,12
        .byte 0,3,12
        .byte 255,2,11
        .byte 254,2,10
        .byte 254,1,9
        .byte 254,0,8
        .byte 254,0,8
        .byte 254,255,7
        .byte 254,254,6
        .byte 254,254,6
        .byte 254,254,6
        .byte 254,254,6
        .byte 254,254,6
        .byte 254,254,6
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,254,4
        .byte 0,251,0

; tiny plane movement table for plane 3
; .word x,y                             ; offset 0, startpos
; .byte count                           ; offset 4 - count
; .byte sprite#                         ; offset 5 - sprite number
; .word current                         ; offset 6 - pointer to current data
; .byte x-add, y-add, sprite-frame      ; offset 8 plus - the actual data
;    (x and y add are signed bytes)
plane_movement_3:
        .word 170,8                     ; x,y
        .byte 113                       ; count
        .byte 2                         ; sprite #
        .word *+2                       ; data ptr
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 254,2,10
        .byte 254,2,9
        .byte 254,1,9
        .byte 254,1,9
        .byte 254,1,9
        .byte 254,0,8
        .byte 254,0,8
        .byte 254,1,7
        .byte 254,1,7
        .byte 254,254,6
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 0,254,4
        .byte 1,254,3
        .byte 2,254,2
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,254,2
        .byte 0,254,4
        .byte 254,255,6
        .byte 254,0,8
        .byte 254,1,10
        .byte 254,1,10
        .byte 254,1,10
        .byte 254,1,10
        .byte 1,3,12
        .byte 1,3,13
        .byte 2,2,14
        .byte 2,1,15
        .byte 3,2,0
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,0,0
        .byte 2,1,15
        .byte 2,2,14
        .byte 1,3,13
        .byte 3,0,12
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 255,3,11
        .byte 254,2,10
        .byte 254,1,9
        .byte 254,0,8
        .byte 254,0,8
        .byte 254,0,8
        .byte 254,0,8
        .byte 254,255,7
        .byte 254,254,6
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 255,254,5
        .byte 0,254,4
        .byte 1,254,3
        .byte 2,254,2
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,255,1
        .byte 2,254,2
        .byte 2,254,2
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 1,254,3
        .byte 0,251,0
.ifndef KERNAL_INC
KERNAL_INC = 1

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

; Kernal
KRNL_GETIN           = $FFE4
KRNL_CHROUT          = $FFD2

KRNL_MEM_FILL        = $FEE4
KRNL_MEM_COPY        = $FEE7
KRNL_MEM_DECOMPRESS  = $FEED

KRNL_GET_DATE_TIME   = $FF50
KRNL_SET_DATE_TIME   = $FF4D

KRNL_SETLFS          = $FFBA
KRNL_SETNAM          = $FFBD
KRNL_OPEN            = $FFC0
KRNL_CHKIN           = $FFC6
KRNL_LOAD            = $FFD5
KRNL_SAVE            = $FFD8
KRNL_ACPTR           = $FFA5
KRNL_MACPTR          = $FF44
KRNL_CLOSE           = $FFC3
KRNL_CLRCHN          = $FFCC
KRNL_CLOSE_ALL       = $FF4A
KRNL_READST          = $FFB7

KRNL_SCREEN          = $FFED
KRNL_PLOT            = $FFF0

KRNL_ERR_TOO_MANY_FILES          = $01
KRNL_ERR_FILE_OPEN               = $02
KRNL_ERR_FILE_NOT_OPEN           = $03
KRNL_ERR_FILE_NOT_FOUND          = $04
KRNL_ERR_DEVICE_NOT_PRESENT      = $05
KRNL_ERR_NOT_INPUT_FILE          = $06
KRNL_ERR_NOT_OUTPUT_FILE         = $07
KRNL_ERR_MISSING_FILENAME        = $08
KRNL_ERR_ILLEGAL_DEVICE_NUMBER   = $09

KEY_A          = 65
KEY_B          = 66
KEY_C          = 67
KEY_D          = 68
KEY_E          = 69
KEY_F          = 70
KEY_G          = 71
KEY_H          = 72
KEY_I          = 73
KEY_J          = 74
KEY_K          = 75
KEY_L          = 76
KEY_M          = 77
KEY_N          = 78
KEY_O          = 79
KEY_P          = 80
KEY_Q          = 81
KEY_R          = 82
KEY_S          = 83
KEY_T          = 84
KEY_U          = 85
KEY_V          = 86
KEY_W          = 87
KEY_X          = 88
KEY_Y          = 89
KEY_Z          = 90

KEY_CRSR_LEFT  = 157
KEY_CRSR_RIGHT = 94
KEY_CRSR_UP    = 95
KEY_CRSR_DOWN  = 145

CHR_NL         = 13
CHR_RETURN     = CHR_NL
CHR_CLEAR      = 147

CHR_COLOR_BLACK      = 144
CHR_COLOR_WHITE      = 5
CHR_COLOR_RED        = 28
CHR_COLOR_CYAN       = 159
CHR_COLOR_PURPLE     = 156
CHR_COLOR_GREEN      = 30
CHR_COLOR_BLUE       = 31
CHR_COLOR_YELLOW     = 158
CHR_COLOR_ORANGE     = 129
CHR_COLOR_BROWN      = 149
CHR_COLOR_LT_RED     = 150
CHR_COLOR_DARK_GRAY  = 151
CHR_COLOR_GRAY       = 152
CHR_COLOR_LT_GREEN   = 153
CHR_COLOR_LT_BLUE    = 154
CHR_COLOR_LT_GRAY    = 155

COLOR_BLACK    = 0
COLOR_WHITE    = 1
COLOR_RED      = 2
COLOR_CYAN     = 3
COLOR_PURPLE   = 4
COLOR_GREEN    = 5
COLOR_BLUE     = 6
COLOR_YELLOW   = 7
COLOR_ORANGE   = 8
COLOR_BROWN    = 9
COLOR_LT_RED   = 10
COLOR_DARK_GRAY = 11
COLOR_GRAY     = 12
COLOR_LT_GREEN    = 13
COLOR_LT_BLUE  = 14
COLOR_LT_GRAY  = 15

IRQVec               = $0314
CHARACTER_COLOR     = $0367

.macro fill_memory start, count, value
   LoadW R0, start
   LoadW R1, count
   lda #value
   jsr KRNL_MEM_FILL
.endmacro

.macro copy_memory source, dest, count
   LoadW R0, source
   LoadW R1, dest
   LoadW R2, count
   jsr KRNL_MEM_COPY
.endmacro

.endif
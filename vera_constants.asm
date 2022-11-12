.ifndef VERA_addr_low
; VERA registers
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_data1        = $9F24
VERA_ctrl         = $9F25
VERA_ien          = $9F26
VERA_isr          = $9F27
VERA_irqline_low  = $9F28
VERA_dc_video     = $9F29
VERA_dc_hscale    = $9F2A
VERA_dc_vscale    = $9F2B
VERA_L0_config    = $9F2D
VERA_L0_mapbase   = $9F2E
VERA_L0_tilebase  = $9F2F
VERA_L1_config    = $9F34
VERA_L1_mapbase   = $9F35
VERA_L1_tilebase  = $9F36

; VRAM Addresses
VRAM_palette      = $1FA00

; map & tile width/height constants
VERA_map_height_32   = %00 << 6
VERA_map_height_64   = %01 << 6
VERA_map_height_128  = %10 << 6
VERA_map_height_256  = %11 << 6

VERA_map_width_32    = %00 << 4
VERA_map_width_64    = %01 << 4
VERA_map_width_128   = %10 << 4
VERA_map_width_256   = %11 << 4

VERA_tile_height_8   = 0 << 1
VERA_tile_height_16  = 1 << 1

VERA_tile_width_8    = 0
VERA_tile_width_16   = 1

; color constants
VERA_colors_2        = %00
VERA_colors_4        = %01
VERA_colors_16       = %10
VERA_colors_256      = %11

; data increments
VERA_increment_0     = 0 << 4
VERA_increment_1     = 1 << 4
VERA_increment_2     = 2 << 4
VERA_increment_4     = 3 << 4
VERA_increment_8     = 4 << 4
VERA_increment_16    = 5 << 4
VERA_increment_32    = 6 << 4
VERA_increment_40    = 11 << 4
VERA_increment_64    = 7 << 4
VERA_increment_80    = 12 << 4
VERA_increment_128   = 8 << 4
VERA_increment_160   = 13 << 4
VERA_increment_256   = 9 << 4
VERA_increment_320   = 14 << 4
VERA_increment_512   = 10 << 4
VERA_increment_640   = 15 << 4
.endif
copy /b ..\screen.bin+..\tiles.bin+..\sprites.bin intro_data.raw
lzsa -v -r -f2 intro_data.raw intro_data.bin
del intro_data.raw

lzsa -v -r -f2 ..\wall_gfx_set_1.bin assets\wall_gfx_set_1.bin
lzsa -v -r -f2 ..\wall_gfx_set_2.bin assets\wall_gfx_set_2.bin
lzsa -v -r -f2 ..\wall_gfx_set_3.bin assets\wall_gfx_set_3.bin
lzsa -v -r -f2 ..\wall_gfx_set_4.bin assets\wall_gfx_set_4.bin
lzsa -v -r -f2 ..\wall_gfx_set_5.bin assets\wall_gfx_set_5.bin
lzsa -v -r -f2 ..\wall_gfx_set_6.bin assets\wall_gfx_set_6.bin
lzsa -v -r -f2 ..\wall_gfx_set_7.bin assets\wall_gfx_set_7.bin

copy ..\palette_gfx*.bin assets

copy ..\sprites.inc intro\intro_sprites.inc
copy ..\palette.bin .

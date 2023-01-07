@echo off

echo ============= intro assets ====================

copy /b ..\intro_screen.bin+..\intro_tiles.bin+..\intro_sprites.bin assets\intro_data.raw
lzsa -v -r -f2 assets\intro_data.raw assets\intro_data.bin
del assets\intro_data.raw
copy ..\intro_sprites.inc intro\intro_sprites.inc
copy ..\intro_palette.bin assets
echo.


echo ============= playfield assets ====================

lzsa -v -r -f2 ..\wall_gfx_set_1.bin assets\wall_gfx_set_1.bin
lzsa -v -r -f2 ..\wall_gfx_set_2.bin assets\wall_gfx_set_2.bin
lzsa -v -r -f2 ..\wall_gfx_set_3.bin assets\wall_gfx_set_3.bin
lzsa -v -r -f2 ..\wall_gfx_set_4.bin assets\wall_gfx_set_4.bin
lzsa -v -r -f2 ..\wall_gfx_set_5.bin assets\wall_gfx_set_5.bin
lzsa -v -r -f2 ..\wall_gfx_set_6.bin assets\wall_gfx_set_6.bin
lzsa -v -r -f2 ..\wall_gfx_set_7.bin assets\wall_gfx_set_7.bin
copy ..\palette_gfx*.bin assets
echo.


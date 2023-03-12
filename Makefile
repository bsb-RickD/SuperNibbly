MAIN_SRC_DIR=src
LIB_SRC_DIR=$(MAIN_SRC_DIR)/lib
UT_SRC_DIR=$(MAIN_SRC_DIR)/unittests
INTRO_SRC_DIR=$(MAIN_SRC_DIR)/intro
TRAVEL_SRC_DIR=$(MAIN_SRC_DIR)/travel
TOOLS_DIR=$(MAIN_SRC_DIR)/tools
ASSET_SRC_DIR=src_assets
ASSETS_DIR=assets

ASSEMBLER=ca65
ARCHIVER=ar65
LINKER=ld65
PYTHON=python3

ASSET_COMPILER=$(TOOLS_DIR)/BuildAssets.py

ASSEMBLER_FLAGS=-I $(MAIN_SRC_DIR) --bin-include-dir  $(MAIN_SRC_DIR) -g -l $(<:%.asm=$(BUILD_DIR)/%.list) --create-dep $(<:%.asm=$(BUILD_DIR)/%.d)
PLATFORM_FLAGS=-t cx16

LINKER_FLAGS=-vm --mapfile $(<:%.o=%.map) -Ln $(<:%.o=%.labels) --dbgfile $(<:%.o=%.debug)
STD_LIBRARY=cx16.lib

CODE_DIRS=$(LIB_SRC_DIR) $(UT_SRC_DIR) $(MAIN_SRC_DIR) $(INTRO_SRC_DIR) $(TRAVEL_SRC_DIR)
BUILD_DIR=build
ASSET_BUILD_DIR=$(BUILD_DIR)/$(ASSETS_DIR)

ALL_BUILD_DIRS=$(foreach D,$(CODE_DIRS),$(BUILD_DIR)/$(D)) $(ASSET_BUILD_DIR)

LIB_SRC_FILES=$(wildcard $(LIB_SRC_DIR)/*.asm)
LIB_OBJ_FILES=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(LIB_SRC_FILES))

UT_SRC_FILES=$(wildcard $(UT_SRC_DIR)/*.asm)
UT_PRG_FILES=$(UT_SRC_FILES:$(UT_SRC_DIR)/%.asm=%.prg)
UT_OBJ_FILES=$(UT_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)

ALL_SRC_FILES=$(foreach D,$(CODE_DIRS),$(wildcard $(D)/*.asm))
ALL_OBJ_FILES=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(ALL_SRC_FILES))

TOOL_SRC_FILES=$(wildcard $(TOOLS_DIR)/*.py)

LIBRARY=$(BUILD_DIR)/lib.lib

INTRO_SRC_FILES=$(MAIN_SRC_DIR)/intro.asm $(INTRO_SRC_DIR)/jumping_fish.asm $(INTRO_SRC_DIR)/dropping_nibbly.asm
INTRO_OBJ_FILES=$(INTRO_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)
INTRO_SRC_ASSETS=$(ASSET_SRC_DIR)/TITEL_BG_x16.png $(ASSET_SRC_DIR)/titanm.png $(ASSET_SRC_DIR)/titanm-1_x16.png $(ASSET_SRC_DIR)/woodly2.png
INTRO_ASSETS=$(ASSETS_DIR)/intro_data.bin $(ASSETS_DIR)/intro_sprites.bin $(ASSETS_DIR)/intro_palette_mapping.bin\
            $(ASSETS_DIR)/intro_palette.bin $(INTRO_SRC_DIR)/intro_sprites_base.inc $(INTRO_SRC_DIR)/intro_sprites.inc

TRAVEL_SRC_FILES=$(MAIN_SRC_DIR)/travel.asm $(TRAVEL_SRC_DIR)/travel_workers.asm
TRAVEL_OBJ_FILES=$(TRAVEL_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)
TRAVEL_SRC_ASSETS=$(ASSET_SRC_DIR)/LMAPP_x16.png $(ASSET_SRC_DIR)/minanm.png
TRAVEL_LANDSCAPES=green ice volcano desert
TRAVEL_ASSETS=$(ASSETS_DIR)/travel_data.bin $(TRAVEL_SRC_DIR)/travel_common_sprites.inc $(TRAVEL_SRC_DIR)/travel_landscape_sprites.inc\
             $(ASSETS_DIR)/travel_palette.bin $(ASSETS_DIR)/travel_palette_mapping.bin\
             $(foreach A,$(TRAVEL_LANDSCAPES),$(ASSETS_DIR)/travel_$(A)_sprites.bin $(TRAVEL_SRC_DIR)/travel_$(A)_pal_indexes.inc)\

ALL_ASSETS=$(INTRO_ASSETS) $(TRAVEL_ASSETS)


PLAYFIELD_SRC_FILES=$(MAIN_SRC_DIR)/playfield.asm
PLAYFIELD_OBJ_FILES=$(PLAYFIELD_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)

EXECUTABLES=intro.prg travel.prg playfield.prg

all: $(UT_PRG_FILES) $(EXECUTABLES)
lib: $(LIBRARY)
exes: $(EXECUTABLES)
unittests: $(UT_PRG_FILES)
folders: $(ALL_BUILD_DIRS)
assets: $(ALL_ASSETS)

#$(info included is $(ALL_SRC_FILES:.asm=.d))

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(UT_PRG_FILES)
	rm -rf $(EXECUTABLES)
	rm -rf $(ALL_ASSETS)

# lib creation 
$(LIBRARY): $(LIB_OBJ_FILES)
	$(ARCHIVER) r $@ $^

# unit test compilation
$(UT_PRG_FILES): %.prg: $(BUILD_DIR)/$(UT_SRC_DIR)/%.o $(LIBRARY)
	$(LINKER) $(PLATFORM_FLAGS) $(LINKER_FLAGS) -o $@ $^ $(STD_LIBRARY)

intro.prg: $(INTRO_OBJ_FILES) $(LIBRARY)
	$(LINKER) $(PLATFORM_FLAGS) $(LINKER_FLAGS) -o $@ $^ $(STD_LIBRARY)

travel.prg: $(TRAVEL_OBJ_FILES) $(LIBRARY)
	$(LINKER) $(PLATFORM_FLAGS) $(LINKER_FLAGS) -o $@ $^ $(STD_LIBRARY)

playfield.prg: $(PLAYFIELD_OBJ_FILES) $(LIBRARY)
	$(LINKER) $(PLATFORM_FLAGS) $(LINKER_FLAGS) -o $@ $^ $(STD_LIBRARY)

# general assembly rule
#    $@: target of rule ($(BUILD_DIR)/%.o in our case), 
#    $< first pre-requisite (%.asm in our case)
#
#    !!! We are not using $^ because, the additional prerequisite, $(ALL_BUILD_DIRS), is not used for compilation
#    $(ALL_BUILD_DIRS) is there so that we don't compile without creating the build dirs
#
#    (see Make automatic variables for explanation on the weird $^, $<, etc.)
#
$(BUILD_DIR)/%.o: %.asm | $(ALL_BUILD_DIRS)
	$(ASSEMBLER) $(PLATFORM_FLAGS) $(ASSEMBLER_FLAGS) $< -o $@

$(BUILD_DIR)/$(MAIN_SRC_DIR)/intro.o: $(INTRO_ASSETS)

$(BUILD_DIR)/$(MAIN_SRC_DIR)/travel.o: $(TRAVEL_ASSETS)

$(INTRO_ASSETS): $(TOOL_SRC_FILES) $(INTRO_SRC_ASSETS)
	$(PYTHON) $(ASSET_COMPILER) $(ASSET_SRC_DIR) $(ASSET_BUILD_DIR) --assets title
	cp $(ASSET_BUILD_DIR)/intro_sprites.inc $(INTRO_SRC_DIR)
	cp $(ASSET_BUILD_DIR)/intro_sprites_base.inc $(INTRO_SRC_DIR)
	cp $(ASSET_BUILD_DIR)/intro_palette.bin $(ASSETS_DIR)
	cp $(ASSET_BUILD_DIR)/intro_palette_mapping.bin $(ASSETS_DIR)
	cat $(ASSET_BUILD_DIR)/intro_screen.bin $(ASSET_BUILD_DIR)/intro_tiles.bin $(ASSET_BUILD_DIR)/intro_sprites_base.bin > $(ASSET_BUILD_DIR)/intro_data.raw
	lzsa -v -r -f2 $(ASSET_BUILD_DIR)/intro_data.raw $(ASSETS_DIR)/intro_data.bin
	-rm -f $(ASSET_BUILD_DIR)/intro_data.raw
	lzsa -v -r -f2 $(ASSET_BUILD_DIR)/intro_sprites.bin $(ASSETS_DIR)/intro_sprites.bin

$(TRAVEL_ASSETS): $(TOOL_SRC_FILES) $(TRAVEL_SRC_ASSETS)
	$(PYTHON) $(ASSET_COMPILER) $(ASSET_SRC_DIR) $(ASSET_BUILD_DIR) --assets travel
	cat $(ASSET_BUILD_DIR)/travel_screen.bin $(ASSET_BUILD_DIR)/travel_tiles.bin $(ASSET_BUILD_DIR)/travel_common_sprites.bin > $(ASSET_BUILD_DIR)/travel_data.raw
	lzsa -v -r -f2 $(ASSET_BUILD_DIR)/travel_data.raw $(ASSETS_DIR)/travel_data.bin
	-rm -f $(ASSET_BUILD_DIR)/travel_data.raw
	$(foreach A,$(TRAVEL_LANDSCAPES),lzsa -v -r -f2 $(ASSET_BUILD_DIR)/travel_$(A)_sprites.bin $(ASSETS_DIR)/travel_$(A)_sprites.bin;)
	cp $(ASSET_BUILD_DIR)/travel_palette.bin $(ASSETS_DIR)
	cp $(ASSET_BUILD_DIR)/travel_palette_mapping.bin $(ASSETS_DIR)
	cp $(ASSET_BUILD_DIR)/travel_green_sprites.inc $(TRAVEL_SRC_DIR)/travel_landscape_sprites.inc
	cp $(ASSET_BUILD_DIR)/travel_common_sprites.inc $(TRAVEL_SRC_DIR)/travel_common_sprites.inc
	$(foreach A,$(TRAVEL_LANDSCAPES),cp $(ASSET_BUILD_DIR)/travel_$(A)_pal_indexes.inc $(TRAVEL_SRC_DIR);)

# create the build dir structure
$(ALL_BUILD_DIRS):
	$(foreach D,$(ALL_BUILD_DIRS),mkdir -p $(D) )

# list the dependency files
DEPFILES=$(ALL_SRC_FILES:%.asm=$(BUILD_DIR)/%.d)

# empty rule for the dep files - see https://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#advanced
$(DEPFILES):

include $(wildcard $(DEPFILES))

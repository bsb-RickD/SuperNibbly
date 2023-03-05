ASSEMBLER=ca65
ARCHIVER=ar65
LINKER=ld65

ASSEMBLER_FLAGS=-I . -g -l $(<:%.asm=$(BUILD_DIR)/%.list) --create-dep $(<:%.asm=$(BUILD_DIR)/%.d)
PLATFORM_FLAGS=-t cx16

LINKER_FLAGS=-vm --mapfile $(<:%.o=%.map) -Ln $(<:%.o=%.labels) --dbgfile $(<:%.o=%.debug)
STD_LIBRARY=cx16.lib

LIB_DIR=lib
UT_DIR=unittests
INTRO_DIR=intro
TRAVEL_DIR=travel
MAIN_DIR=.

CODE_DIRS=$(LIB_DIR) $(UT_DIR) $(MAIN_DIR) $(INTRO_DIR) $(TRAVEL_DIR)
BUILD_DIR=build

ALL_BUILD_DIRS=$(foreach D,$(CODE_DIRS),$(BUILD_DIR)/$(D))

LIB_SRC_FILES=$(wildcard $(LIB_DIR)/*.asm)
LIB_OBJ_FILES=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(LIB_SRC_FILES))

UT_SRC_FILES=$(wildcard $(UT_DIR)/*.asm)
UT_PRG_FILES=$(UT_SRC_FILES:$(UT_DIR)/%.asm=%.prg)
UT_OBJ_FILES=$(UT_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)

ALL_SRC_FILES=$(foreach D,$(CODE_DIRS),$(wildcard $(D)/*.asm))
ALL_OBJ_FILES=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(ALL_SRC_FILES))

LIBRARY=$(BUILD_DIR)/$(LIB_DIR)/lib.lib

INTRO_SRC_FILES=intro.asm $(INTRO_DIR)/jumping_fish.asm $(INTRO_DIR)/dropping_nibbly.asm
INTRO_OBJ_FILES=$(INTRO_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)

TRAVEL_SRC_FILES=travel.asm $(TRAVEL_DIR)/travel_workers.asm
TRAVEL_OBJ_FILES=$(TRAVEL_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)

PLAYFIELD_SRC_FILES=playfield.asm
PLAYFIELD_OBJ_FILES=$(PLAYFIELD_SRC_FILES:%.asm=$(BUILD_DIR)/%.o)

EXECUTABLES=intro.prg travel.prg playfield.prg

all: $(UT_PRG_FILES) $(EXECUTABLES)
lib: $(LIBRARY)
unittests: $(UT_PRG_FILES)
folders: $(ALL_BUILD_DIRS)

#$(info included is $(ALL_SRC_FILES:.asm=.d))

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(UT_PRG_FILES)


# lib creation 
$(LIBRARY): $(LIB_OBJ_FILES)
	$(ARCHIVER) r $@ $^

# unit test compilation
$(UT_PRG_FILES): %.prg: $(BUILD_DIR)/$(UT_DIR)/%.o $(LIBRARY)
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

# create the build dir structure
$(ALL_BUILD_DIRS):
	$(foreach D,$(ALL_BUILD_DIRS),mkdir -p $(D) )

# list the dependency files
DEPFILES=$(ALL_SRC_FILES:%.asm=$(BUILD_DIR)/%.d)

# empty rule for the dep files - see https://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#advanced
$(DEPFILES):

include $(wildcard $(DEPFILES))

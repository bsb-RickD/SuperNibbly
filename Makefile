ASSEMBLER=ca65
ARCHIVER=ar65
LINKER=ld65

ASSEMBLER_FLAGS=-I . -l $(<:%.asm=$(BUILD_DIR)/%.list) --create-dep $(<:%.asm=$(BUILD_DIR)/%.d)
PLATFORM_FLAGS=-t cx16

LINKER_FLAGS=--mapfile $(<:%.o=%.map)
STD_LIBRARY=cx16.lib

LIB_DIR=lib
UT_DIR=unittests
MAIN_DIR=.

CODE_DIRS=$(LIB_DIR) $(UT_DIR) $(MAIN_DIR)
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

all: $(UT_PRG_FILES)
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
	$(LINKER) $(PLATFORM_FLAGS) $(LINKER_FLAGS) -o $@ $< $(LIBRARY) $(STD_LIBRARY)

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

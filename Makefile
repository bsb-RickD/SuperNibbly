ASSEMBLER=ca65
ARCHIVER=ar65
LINKER=ld65

INC_DIRS=-I .
ASM_FLAGS=-t cx16
LIB_DIR=lib
UT_DIR=unittests
MAIN_DIR=.

CODE_DIRS=$(LIB_DIR) $(UT_DIR) $(MAIN_DIR)
BUILD_DIR=build

LIB_BUILD_DIR=$(LIB_DIR)/$(BUILD_DIR)
UT_BUILD_DIR=$(UT_DIR)/$(BUILD_DIR)

LIB_SRC_FILES=$(wildcard $(LIB_DIR)/*.asm)
LIB_OBJ_FILES=$(patsubst $(LIB_DIR)/%.asm,$(LIB_BUILD_DIR)/%.o,$(LIB_SRC_FILES))

UT_SRC_FILES=$(wildcard $(UT_DIR)/*.asm)
UT_OBJ_FILES=$(patsubst $(UT_DIR)/%.asm,$(UT_BUILD_DIR)/%.o,$(UT_SRC_FILES))
UT_PRG_FILES=$(patsubst $(UT_DIR)/%.asm,./%.prg,$(UT_SRC_FILES))

#ALL_SRC_FILES=$(foreach D,$(CODE_DIRS),$(wildcard $(D)/*.asm))
#ALL_OBJ_FILES=$(patsubst $(LIB_DIR)/%.asm,$(LIB_BUILD_DIR)/%.o,$(ALL_SRC_FILES))

#$(info LIB_SRC_FILES is $(LIB_SRC_FILES))

LIBRARY=$(LIB_DIR)/lib.lib

all: $(LIBRARY) $(UT_PRG_FILES)

clean:
	rm -rf $(LIB_BUILD_DIR) $(UT_BUILD_DIR) $(LIBRARY)

# lib creation 
$(LIB_OBJ_FILES): $(LIB_BUILD_DIR)/%.o: $(LIB_DIR)/%.asm
	$(ASSEMBLER) $(ASM_FLAGS) $(INC_DIRS) -l $(patsubst %.o,%.list,$@) $< -o $@

$(LIBRARY): $(LIB_BUILD_DIR) $(LIB_OBJ_FILES)
	$(ARCHIVER) r $(LIBRARY) $(LIB_OBJ_FILES)

$(LIB_BUILD_DIR):
	mkdir $(LIB_BUILD_DIR)

# unit tests
$(UT_OBJ_FILES): $(UT_BUILD_DIR)/%.o: $(UT_DIR)/%.asm
	$(ASSEMBLER) $(ASM_FLAGS) $(INC_DIRS) -l $(patsubst %.o,%.list,$@) $< -o $@



$(UT_BUILD_DIR):
	mkdir $(UT_BUILD_DIR)




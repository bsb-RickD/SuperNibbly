ASSEMBLER=ca65
ARCHIVER=ar65
LINKER=ld65

INC_DIRS=-I .
PLATFORM_FLAGS=-t cx16
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
UT_OBJ_FILES=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(UT_SRC_FILES))
UT_PRG_FILES=$(patsubst $(UT_DIR)/%.asm,./%.prg,$(UT_SRC_FILES))

ALL_SRC_FILES=$(foreach D,$(CODE_DIRS),$(wildcard $(D)/*.asm))
ALL_OBJ_FILES=$(patsubst %.asm,$(BUILD_DIR)/%.o,$(ALL_SRC_FILES))

#$(info ALL_SRC_FILES is $(ALL_SRC_FILES))

LIBRARY=$(BUILD_DIR)/$(LIB_DIR)/lib.lib

all: $(ALL_BUILD_DIRS) $(UT_PRG_FILES)
lib: $(ALL_BUILD_DIRS) $(LIBRARY)
unittests: $(ALL_BUILD_DIRS) $(UT_PRG_FILES)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(UT_PRG_FILES)


# lib creation 
$(LIBRARY): $(LIB_OBJ_FILES)
	$(ARCHIVER) r $@ $^

# unit test compilation (#$@: target of rule, $< prerequiste for target?)
%.prg: $(BUILD_DIR)/$(UT_DIR)/%.o $(LIBRARY)
	$(LINKER) $(PLATFORM_FLAGS) --mapfile $(patsubst %.o,%.map,$<) -o $@ $< $(LIBRARY) $(STD_LIBRARY)


# general assembly rule
$(BUILD_DIR)/%.o: %.asm
	$(ASSEMBLER) $(PLATFORM_FLAGS) $(INC_DIRS) -l $(patsubst %.o,%.list,$@) $^ -o $@

# create the build dir structure
$(ALL_BUILD_DIRS):
	$(foreach D,$(ALL_BUILD_DIRS),mkdir -p $(D) )

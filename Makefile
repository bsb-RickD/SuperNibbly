ASSEMBLER=ca65
ARCHIVER=ar65
LINKER=ld65

INC_DIRS=-I .
ASM_FLAGS=-t cx16
LIB_DIR=lib
BUILD_DIR=build
LIB_BUILD_DIR=$(LIB_DIR)/$(BUILD_DIR)

LIB_SRC_FILES=$(wildcard $(LIB_DIR)/*.asm)
LIB_OBJ_FILES=$(patsubst $(LIB_DIR)/%.asm,$(LIB_BUILD_DIR)/%.o,$(LIB_SRC_FILES))

#$(info LIB_SRC_FILES is $(LIB_SRC_FILES))

LIBRARY=$(LIB_DIR)/lib.lib

all: $(LIBRARY)

clean:
	rm -rf $(LIB_BUILD_DIR) $(LIBRARY)

$(LIB_OBJ_FILES): $(LIB_BUILD_DIR)/%.o : $(LIB_DIR)/%.asm
	$(ASSEMBLER) $(ASM_FLAGS) $(INC_DIRS) -l $(patsubst %.o,%.list,$@) $< -o $@

$(LIBRARY): $(LIB_BUILD_DIR) $(LIB_OBJ_FILES)
	$(ARCHIVER) r $(LIBRARY) $(LIB_OBJ_FILES)

$(LIB_BUILD_DIR):
	mkdir $(LIB_BUILD_DIR)

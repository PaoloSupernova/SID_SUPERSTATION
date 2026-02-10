# SID SUPERSTATION - Makefile
# Builds the C64 synthesizer program using KickAssembler

# Assembler configuration
ASM = java -jar KickAss.jar
ASMFLAGS = -showmem

# Directories
SRC_DIR = src
BUILD_DIR = build
PATCHES_DIR = patches

# Output file
OUTPUT = $(BUILD_DIR)/sid_superstation.prg

# Source files
SOURCES = $(SRC_DIR)/main.asm \
          $(SRC_DIR)/constants.asm \
          $(SRC_DIR)/tables.asm \
          $(SRC_DIR)/sid.asm \
          $(SRC_DIR)/synth_engine.asm \
          $(SRC_DIR)/sequencer.asm \
          $(SRC_DIR)/ui.asm \
          $(SRC_DIR)/input.asm \
          $(SRC_DIR)/storage.asm

# Default target
all: dirs $(OUTPUT)

# Create build directory
dirs:
	@mkdir -p $(BUILD_DIR)

# Build the program
$(OUTPUT): $(SOURCES)
	$(ASM) $(ASMFLAGS) -o $(OUTPUT) $(SRC_DIR)/main.asm

# Run in VICE emulator
run: $(OUTPUT)
	x64 $(OUTPUT)

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

# Generate frequency table
freqtable:
	python3 tools/freq_calc.py > $(SRC_DIR)/freq_table_data.asm

.PHONY: all dirs run clean freqtable

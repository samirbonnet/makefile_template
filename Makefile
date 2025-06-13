# Advanced Makefile Template for C/C++ Projects
# ==============================================
#
# Usage:
#   make [target] [VARIABLE=value]
#
# Targets:
#   all        : Build the release version (default)
#   debug      : Build the debug version
#   release    : Build the release version
#   clean      : Remove all generated files
#   run        : Build and run the release version
#   run_debug  : Build and run the debug version
#   format     : Format source files using clang-format
#   lint       : Run static analysis using clang-tidy
#   help       : Display this help message
#
# Variables:
#   CC         : C compiler command
#   CXX        : C++ compiler command
#   CFLAGS     : C compiler flags
#   CXXFLAGS   : C++ compiler flags
#   INCLUDES   : Include directories
#   LIBS       : Libraries to link
#   TARGET     : Name of the output executable
#
# Example:
#   make debug CC=clang CXX=clang++ TARGET=myapp

# Color codes for pretty output
BLUE := \033[1;34m
GREEN := \033[1;32m
RED := \033[1;31m
YELLOW := \033[1;33m
RESET := \033[0m

# Compiler settings
CC := gcc
CXX := g++
CFLAGS := -std=gnu17 -Wall -Wextra -pedantic
CXXFLAGS := -std=gnu++20 -Wall -Wextra -pedantic
INCLUDES := -Iinc
LIBS :=

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
INC_DIR := inc

# Files
SRCS := $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(filter %.cpp,$(SRCS))) \
        $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(filter %.c,$(SRCS)))

# Target executable
TARGET := $(BIN_DIR)/main

# Determine the build type (release by default)
BUILD_TYPE ?= release

# Conditional flags based on build type
ifeq ($(BUILD_TYPE),debug)
    CFLAGS += -ggdb3 -Og -DDEBUG
    CXXFLAGS += -ggdb3 -Og -DDEBUG
else
    CFLAGS += -DNDEBUG -O3 -march=native
    CXXFLAGS += -DNDEBUG -O3 -march=native
endif

# Phony targets
.PHONY: all debug release clean run run_debug format lint help ccdb

# Default target
all: release

# Build targets
debug: BUILD_TYPE := debug
debug: $(TARGET)

release: BUILD_TYPE := release
release: $(TARGET)

# Linking
$(TARGET): $(OBJS) | $(BIN_DIR)
	@echo "$(BLUE)Linking $@$(RESET)"
	@$(CXX) $(CXXFLAGS) $^ -o $@ $(LIBS)
	@echo "$(GREEN)Build complete: $@$(RESET)"

# Pattern rule for C++ compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@echo "$(BLUE)Compiling $<$(RESET)"
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Pattern rule for C compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo "$(BLUE)Compiling $<$(RESET)"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Create directories
$(BIN_DIR) $(OBJ_DIR):
	@mkdir -p $@

# Clean
clean:
	@echo "$(RED)Cleaning up$(RESET)"
	@rm -rf $(OBJ_DIR) $(BIN_DIR)

# Run targets
run: release
	@echo "$(GREEN)Running release build$(RESET)"
	@./$(TARGET)

run_debug: debug
	@echo "$(YELLOW)Running debug build$(RESET)"
	@./$(TARGET)

# Format source files
format:
	@echo "$(BLUE)Formatting source files$(RESET)"
	@find $(SRC_DIR) $(INC_DIR) -iname *.hpp -o -iname *.cpp -o -iname *.c -o -iname *.h | xargs clang-format -i -style=file
	@echo "$(GREEN)Formatting complete$(RESET)"

# Lint source files
lint: compile_commands.json
	@echo "$(BLUE)Running static analysis$(RESET)"
	@find $(SRC_DIR) -iname *.cpp -o -iname *.c | xargs clang-tidy -p compile_commands.json
	@echo "$(GREEN)Static analysis complete$(RESET)"

compile_commands.json:
	@echo "$(BLUE)Generating compilation database$(RESET)"
	@bear -- $(MAKE) -B $(TARGET) > /dev/null
	@echo "$(GREEN)Compilation database created$(RESET)"

ccdb: compile_commands.json

# Help
help:
	@echo "$(YELLOW)Available targets:$(RESET)"
	@echo "  $(BLUE)all$(RESET)        : Build the release version (default)"
	@echo "  $(BLUE)debug$(RESET)      : Build the debug version"
	@echo "  $(BLUE)release$(RESET)    : Build the release version"
	@echo "  $(BLUE)clean$(RESET)      : Remove all generated files"
	@echo "  $(BLUE)run$(RESET)        : Build and run the release version"
	@echo "  $(BLUE)run_debug$(RESET)  : Build and run the debug version"
	@echo "  $(BLUE)format$(RESET)     : Format source files using clang-format"
	@echo "  $(BLUE)lint$(RESET)       : Run static analysis using clang-tidy"
	@echo "  $(BLUE)help$(RESET)       : Display this help message"

# Include dependencies
-include $(OBJS:.o=.d)

# Generate dependencies for C++
$(OBJ_DIR)/%.d: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -MM -MT '$(OBJ_DIR)/$*.o $@' $< > $@

# Generate dependencies for C
$(OBJ_DIR)/%.d: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@$(CC) $(CFLAGS) $(INCLUDES) -MM -MT '$(OBJ_DIR)/$*.o $@' $< > $@

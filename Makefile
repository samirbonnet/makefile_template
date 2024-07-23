# Makefile for C++23 Project

# Compiler settings
CXX := g++
CXXFLAGS := -std=c++23 -Wall -Wextra -pedantic -O2
INCLUDES := -Iinclude
LIBS :=

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
LIB_DIR := lib

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

# Main target
TARGET := $(BIN_DIR)/main

# Phony targets
.PHONY: all clean debug release

# Default target
all: release

# Release build
release: CXXFLAGS += -DNDEBUG
release: $(TARGET)

# Debug build
debug: CXXFLAGS += -g -DDEBUG
debug: $(TARGET)

# Linking
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LIBS)

# Compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Create directories
$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

# Clean
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Include dependencies
-include $(OBJS:.o=.d)

# Generate dependencies
$(OBJ_DIR)/%.d: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -MM -MT '$(OBJ_DIR)/$*.o $@' $< > $@

# Run the program
run: $(TARGET)
	./$(TARGET)

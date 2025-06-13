cmake_minimum_required(VERSION 3.12)
project(ccpp_demo LANGUAGES C CXX)

# Set C standards
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add include directory for all targets
set(PROJECT_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)

# Sources
set(C_SOURCES src/c_functions.c)
set(CPP_SOURCES src/cpp_class.cpp)

# Create libraries
add_library(c_functions STATIC ${C_SOURCES})
target_include_directories(c_functions PUBLIC ${PROJECT_INCLUDE_DIR})

add_library(cpp_class STATIC ${CPP_SOURCES})
target_include_directories(cpp_class PUBLIC ${PROJECT_INCLUDE_DIR})

# Executable
add_executable(main src/main.cpp)
target_include_directories(main PRIVATE ${PROJECT_INCLUDE_DIR})
target_link_libraries(main PRIVATE c_functions cpp_class)

# Install rules
install(TARGETS main c_functions cpp_class
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib)

install(DIRECTORY include/ DESTINATION include)

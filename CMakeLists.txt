cmake_minimum_required(VERSION 4.0.0)
project(pika-8-game 
    VERSION 1.0.0 
    DESCRIPTION "Demo game using Pika-8 engine"
    LANGUAGES C CXX)

# Project metadata
set(PROJECT_LICENSE "MIT")

# exe will be created in the project root
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_SOURCE_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR})

# Build Lua from a single amalgamated source by default.
option(PIKA_USE_ONELUA "Use onelua.c for Lua build" ON)

add_subdirectory(pika-8-engine)


cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)

project(main C CXX ASM)
pico_sdk_init()

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

add_executable(main main.c)

pico_enable_stdio_uart(main 1)


add_subdirectory(lib)


# Link direct dependencies of the project.
target_link_libraries(main
	PUBLIC
	comlib
)




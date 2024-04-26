project(comlib)

add_library(${PROJECT_NAME})

target_include_directories(${PROJECT_NAME} INTERFACE ${PROJECT_SOURCE_DIR})

target_link_libraries(${PROJECT_NAME} PUBLIC logger pico_stdlib hardware_gpio )
target_sources(${PROJECT_NAME}
    PRIVATE
        comlib.h
)
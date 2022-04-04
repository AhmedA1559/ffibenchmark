cmake_minimum_required(VERSION 3.21)
#set(CMAKE_GENERATOR_PLATFORM x64)

project(http-server C)

set(CMAKE_C_STANDARD 17)

add_library(http-server SHARED library.c mjson.c)

link_libraries(ws2_32 wsock32)

add_subdirectory("MongooseCMake") # or any other folder where this project is downloaded to
target_link_libraries(http-server
        PUBLIC
        mongoose
        )

add_definitions(-DSDL_MAIN_HANDLED)
cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(nbody_library VERSION 1.0.0 LANGUAGES C)
add_library(nbody_library nbody.c)

set_target_properties(nbody_library PROPERTIES
    PUBLIC_HEADER nbody.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    OUTPUT_NAME "nbody"
)
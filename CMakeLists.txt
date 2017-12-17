cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

project(lua-protobuf)

set(OUTPUT_PATH "${PROJECT_SOURCE_DIR}/bin")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_PATH})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_PATH})

######################################################################
#
######################################################################
set(TARGET_NAME pb)

include_directories(lua/include)
link_directories(lua/lib)
add_definitions(-DPB_IMPLEMENTATION)

set(SOURCE_FILES 
	lua-protobuf/pb.c
	lua-protobuf/pb.h
	lua-protobuf/pb_extends.h
)

add_library(${TARGET_NAME} SHARED ${SOURCE_FILES})
target_link_libraries(${TARGET_NAME} lua)

install(TARGETS ${TARGET_NAME}
	ARCHIVE DESTINATION lib)

######################################################################
#
######################################################################
set(TARGET_NAME ltest)

include_directories(lua/include lua-protobuf)
link_directories(lua/lib)

add_executable(${TARGET_NAME} test/main.cpp)
target_link_libraries(${TARGET_NAME} lua pb)

if(MSVC )
	set_target_properties(${TARGET_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY ${OUTPUT_PATH})
endif()

install(TARGETS ${TARGET_NAME}
	RUNTIME DESTINATION bin)


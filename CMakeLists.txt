cmake_minimum_required(VERSION 3.0.0 FATAL_ERROR)

project(lua-protobuf)

set(OUTPUT_PATH "${PROJECT_SOURCE_DIR}/bin")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${OUTPUT_PATH})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${OUTPUT_PATH})

######################################################################
# lua
######################################################################
set(TARGET_NAME lua)
set(SOURCE_FILES 
	lua/lapi.c
	lua/lauxlib.c
	lua/lbaselib.c
	lua/lcode.c
	lua/ldblib.c
	lua/ldebug.c
	lua/ldo.c
	lua/ldump.c
	lua/lfunc.c
	lua/lgc.c
	lua/linit.c
	lua/liolib.c
	lua/llex.c
	lua/lmathlib.c
	lua/lmem.c
	lua/loadlib.c
	lua/lobject.c
	lua/lopcodes.c
	lua/loslib.c
	lua/lparser.c
	lua/lstate.c
	lua/lstring.c
	lua/lstrlib.c
	lua/ltable.c
	lua/ltablib.c
	lua/ltm.c
	# lua/lua.c
	# lua/luac.c
	lua/lundump.c
	lua/lvm.c
	lua/lzio.c
)

add_definitions(-DLUA_BUILD_AS_DLL)

add_library(${TARGET_NAME} SHARED ${SOURCE_FILES})
install(TARGETS ${TARGET_NAME}
	ARCHIVE DESTINATION lib)
######################################################################
# pb
######################################################################
set(TARGET_NAME pb)

include_directories(lua)
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
# test
######################################################################
set(TARGET_NAME ltest)

include_directories(lua lua-protobuf)

add_executable(${TARGET_NAME} test/main.c)
target_link_libraries(${TARGET_NAME} lua pb)

if(MSVC )
	set_target_properties(${TARGET_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY ${OUTPUT_PATH})
endif()

install(TARGETS ${TARGET_NAME}
	RUNTIME DESTINATION bin)


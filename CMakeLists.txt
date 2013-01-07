cmake_minimum_required(VERSION 2.6)

project(dse)
set(CMAKE_C_FLAGS "-Wall")
option(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
option(CMAKE_C_FLAGS_RELEASE "-O2 -g0")

find_library(HAVE_LIBEVENT NAMES event)
find_library(HAVE_MINIKONOHA NAMES minikonoha)

add_executable(dse dse.c)
if(HAVE_LIBEVENT)
	set(DSE_EXTRA_LIBRARY ${DSE_EXTRA_LIBRARY} event)
endif(HAVE_LIBEVENT)
if(HAVE_MINIKONOHA)
	set(DSE_EXTRA_LIBRARY ${DSE_EXTRA_LIBRARY} minikonoha)
endif(HAVE_MINIKONOHA)
target_link_libraries(dse ${DSE_EXTRA_LIBRARY})

#set(_DSE_SCRIPT_DIR lib/minikonoha/${SO_VERSION}/dse)
#set(DSE_SCRIPT_CODE script/dse.k)
#install(TARGETS dse DESTINATION bin)
#install(FILES ${DSE_PLATFORM_SCRIPT_CODE} DESTINATION ${_DSE_SCRIPT_DIR})

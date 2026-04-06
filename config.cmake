set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release" CACHE STRING "Limited Configs" FORCE)

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Build type" FORCE)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/platform.cmake")

set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(USE_MSVC_RUNTIME_LIBRARY_DLL OFF CACHE BOOL "" FORCE)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

if(MSVC)
	add_compile_options(/EHsc)
endif()

# Multi-config safe: $<CONFIG>. Layout: build/<os_arch>/<Config>/
set(_cmake_base_out "${CMAKE_BINARY_DIR}/${CMAKE_BASE_PLATFORM_SEGMENT}/$<CONFIG>")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${_cmake_base_out}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${_cmake_base_out}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${_cmake_base_out}")
unset(_cmake_base_out)

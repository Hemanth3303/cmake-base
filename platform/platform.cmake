# Platform = {OS}_{ARCH}_{COMPILER}
# This is used to generate the build output directory.

include_guard()

include("${CMAKE_CURRENT_LIST_DIR}/architecture.cmake" REQUIRED)
include("${CMAKE_CURRENT_LIST_DIR}/os.cmake" REQUIRED)
include("${CMAKE_CURRENT_LIST_DIR}/compiler.cmake" REQUIRED)

set(_cmake_base_target_platform "${_cmake_base_target_os}_${_cmake_base_target_architecture}_${_cmake_base_build_compiler}")

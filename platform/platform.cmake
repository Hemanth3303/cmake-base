# For this file, Platform = {OS}-{ARCH}-{COMPILER}
# This is used to generate the build output directory too.

include("${CMAKE_CURRENT_LIST_DIR}/architecture.cmake" REQUIRED)
include("${CMAKE_CURRENT_LIST_DIR}/os.cmake" REQUIRED)
include("${CMAKE_CURRENT_LIST_DIR}/compiler.cmake" REQUIRED)

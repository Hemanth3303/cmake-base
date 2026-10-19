# Detect the build compiler (MSVC, GNU-GCC, LLVM-Clang, etc)

if (CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" OR CMAKE_C_COMPILER_ID STREQUAL "AppleClang")
	set(_cmake_base_build_compiler "apple-clang")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
	if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC" OR CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")
		set(_cmake_base_build_compiler "clang-cl")
	else()
		set(_cmake_base_build_compiler "llvm-clang")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER_ID STREQUAL "GNU")
	if(MINGW)
		if(CMAKE_CXX_COMPILER_TARGET MATCHES "w64" OR CMAKE_C_COMPILER_TARGET MATCHES "w64")
			set(_cmake_base_build_compiler "mingw-w64-gcc")
		else()
			set(_cmake_base_build_compiler "mingw32-gcc")
		endif()
	else()
		set(_cmake_base_build_compiler "gnu-gcc")
	endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" OR CMAKE_C_COMPILER_ID STREQUAL "MSVC")
	set(_cmake_base_build_compiler "msvc")
else()
	set(_cmake_base_build_compiler "unknown")
	message(WARNING
		"cmake-base: unrecognized C++ compiler;"
		"using _cmake_base_build_compiler=unknown"
	)
endif()

# Example usage:
#	cmake_base_target_compiler_definitions(Application MY_COOL_APP)
# This defines something like MY_COOL_APP_COMPILER_GNU_GCC=1 for the
# cmake target(executable, library, etc) named Application.
function(cmake_base_target_compiler_definitions target prefix)
	if(NOT prefix MATCHES "^[A-Za-z_][A-Za-z0-9_]*$")
		message(
			FATAL_ERROR
			"cmake_base_target_compiler_definitions: invalid prefix '${prefix}' (need C identifier stem)"
		)
	endif()

	if(_cmake_base_build_compiler STREQUAL "apple-clang")
		set(_suffix "APPLE_CLANG")
	elseif(_cmake_base_build_compiler STREQUAL "clang-cl")
		set(_suffix "CLANG_CL")
	elseif(_cmake_base_build_compiler STREQUAL "llvm-clang")
		set(_suffix "LLVM_CLANG")
	elseif(_cmake_base_build_compiler STREQUAL "mingw-w64-gcc")
		set(_suffix "MINGW_W64_GCC")
	elseif(_cmake_base_build_compiler STREQUAL "mingw32-gcc")
		set(_suffix "MINGW32_GCC")
	elseif(_cmake_base_build_compiler STREQUAL "mingw32-gcc")
		set(_suffix "MINGW32_GCC")
	elseif(_cmake_base_build_compiler STREQUAL "gnu-gcc")
		set(_suffix "GNU_GCC")
	elseif(_cmake_base_build_compiler STREQUAL "msvc")
		set(_suffix "MSVC")
	elseif(_cmake_base_build_compiler STREQUAL "unknown")
		set(_suffix "UNKNOWN")
	else()
		message(
			FATAL_ERROR
			"cmake_base_target_compiler_definitions: internal error, _cmake_base_build_compiler='${_cmake_base_build_compiler}'"
			)
	endif()
	target_compile_definitions("${target}" PRIVATE "${prefix}_COMPILER_${_suffix}=1")
	unset(_suffix)
endfunction()

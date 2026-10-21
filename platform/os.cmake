# Detects TARGET OS(Windowm Linux, Darwin, etc)
# Note: This is NOT the HOST OS(CMAKE_HOST_SYSTEM_NAME)

include_guard()

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	set(_cmake_base_target_os "windows")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	set(_cmake_base_target_os "linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
	set(_cmake_base_target_os "darwin")
elseif(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
	set(_cmake_base_target_os "freebsd")
elseif(CMAKE_SYSTEM_NAME STREQUAL "OpenBSD")
	set(_cmake_base_target_os "openbsd")
elseif(CMAKE_SYSTEM_NAME STREQUAL "NetBSD")
	set(_cmake_base_target_os "netbsd")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Android")
	set(_cmake_base_target_os "android")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
	set(_cmake_base_target_os "emscripten")
elseif(CMAKE_SYSTEM_NAME STREQUAL "iOS")
	set(_cmake_base_target_os "ios")
else()
	set(_cmake_base_target_os "unknown")
	message(WARNING
		"cmake-base: unrecognized CMAKE_SYSTEM_NAME='${CMAKE_SYSTEM_NAME}';"
		"using _cmake_base_target_os=unknown"
	)
endif()

# Example usage:
#	cmake_base_apply_os_definitions_to_target(Application MY_COOL_APP)
# This defines something like MY_COOL_APP_OS_LINUX=1 for the
# cmake target(executable, library, etc) named Application.
function(cmake_base_apply_os_definitions_to_target target prefix)
	if(NOT prefix MATCHES "^[A-Za-z_][A-Za-z0-9_]*$")
		message(
			FATAL_ERROR
			"cmake_base_apply_os_definitions_to_target: invalid prefix '${prefix}' (need C identifier stem)"
		)
	endif()

	string(TOUPPER "${_cmake_base_target_os}" _suffix)
	target_compile_definitions("${target}" PRIVATE "${prefix}_OS_${_suffix}=1")
	unset(_suffix)

endfunction()

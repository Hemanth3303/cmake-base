# Detect TARGET Architecture (x86, ARM, etc)

string(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" _cmake_base_processor)

if(_cmake_base_processor STREQUAL "")
	set(_cmake_base_target_architecture "unknown")
	message(
		WARNING
		"cmake-base: CMAKE_SYSTEM_PROCESSOR is empty;"
		"using _cmake_base_target_architecture=unknown"
	)
elseif(_cmake_base_processor MATCHES "^(amd64|x86_64)$")
	set(_cmake_base_target_architecture "x86-64")
elseif(_cmake_base_processor MATCHES "^(i386|i686|x86)$")
	set(_cmake_base_target_architecture "x86-32")
elseif(_cmake_base_processor MATCHES "^(arm64|aarch64)$")
	set(_cmake_base_target_architecture "aarch64")
elseif(_cmake_base_processor MATCHES "^riscv32")
	set(_cmake_base_target_architecture "riscv32")
elseif(_cmake_base_processor MATCHES "^riscv64")
	set(_cmake_base_target_architecture "riscv64")
elseif(
	(_cmake_base_processor MATCHES "^armv[0-9]")
	OR (_cmake_base_processor STREQUAL "arm")
	OR (_cmake_base_processor MATCHES "^armeb")
)
	set(_cmake_base_target_architecture "aarch32")
else()
	set(_cmake_base_target_architecture "unknown")
	message(
		WARNING
		"cmake-base: unrecognized CMAKE_SYSTEM_PROCESSOR='${CMAKE_SYSTEM_PROCESSOR}' (normalized='${_cmake_base_processor}');"
		"using _cmake_base_target_architecture=unknown"
	)
endif()

# Example usage:
#	cmake_base_target_platform_definitions(Application MY_COOL_APP)
# This generates something like MY_COOL_APP_ARCHITECTURE_X86_64 for the
# cmake target(executable, library, etc) named Application.
function(cmake_base_target_architecture_definitions target prefix)
	if(NOT prefix MATCHES "^[A-Za-z_][A-Za-z0-9_]*$")
		message(
			FATAL_ERROR
			"cmake_base_target_architecture_definitions: invalid prefix '${prefix}' (need C identifier stem)"
		)
	endif()

	if(_cmake_base_target_architecture STREQUAL "x86-32")
		set(_suffix "X86_32")
	elseif(_cmake_base_target_architecture STREQUAL "x86-64")
		set(_suffix "X86_64")
	elseif(_cmake_base_target_architecture STREQUAL "aarch32")
		set(_suffix "AARCH32")
	elseif(_cmake_base_target_architecture STREQUAL "aarch64")
		set(_suffix "AARCH64")
	elseif(_cmake_base_target_architecture STREQUAL "riscv32")
		set(_suffix "RISCV32")
	elseif(_cmake_base_target_architecture STREQUAL "riscv64")
		set(_suffix "RISCV64")
	elseif(_cmake_base_target_architecture STREQUAL "unknown")
		set(_suffix "UNKNOWN")
	else()
		message(
			FATAL_ERROR
			"cmake_base_target_architecture_definitions: internal error, _cmake_base_target_architecture='${_cmake_base_target_architecture}'"
			)
	endif()
	target_compile_definitions("${target}" PRIVATE "${prefix}_ARCHITECTURE_${_suffix}=1")
	unset(_suffix)
endfunction()

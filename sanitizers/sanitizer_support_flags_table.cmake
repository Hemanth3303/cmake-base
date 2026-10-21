# Compiler family + flags table

include_guard()

# As far as I'm aware (2026-10-21), the current compiler support for sanitizers is:
# 	Linux gcc = asan, ubsan, tsan
# 	Linux llvm-clang = asan, ubsan, tsan
# 	Windows msvc = asan
# 	Windows mingw-w64 = none
# 	Windows mingw32 = none
# 	Windows clang-cl = idk, conflicting info online, so assuming as none
# 	Windows llvm-clang (gnu style command line) = asan and ubsan
# 	Apple clang = asan, ubsan and tsan

set(_cmake_base_sanitizer_family "unsupported")

set(_cmake_base_sanitizer_asan_compiler_flags "")
set(_cmake_base_sanitizer_asan_linker_flags "")

set(_cmake_base_sanitizer_ubsan_compiler_flags "")
set(_cmake_base_sanitizer_ubsan_linker_flags "")

set(_cmake_base_sanitizer_tsan_compiler_flags "")
set(_cmake_base_sanitizer_tsan_linker_flags "")

set(_cmake_base_sanitizer_aux_compiler_flags "")
set(_cmake_base_sanitizer_aux_linker_flags "")

if(_cmake_base_build_compiler STREQUAL "gnu-gcc" AND _cmake_base_target_os STREQUAL "linux")
	set(_cmake_base_sanitizer_family "linux-gnu-gcc")

	set(_cmake_base_sanitizer_asan_compiler_flags "-fsanitize=address")
	set(_cmake_base_sanitizer_asan_linker_flags "-fsanitize=address")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "-fsanitize=undefined")
	set(_cmake_base_sanitizer_ubsan_linker_flags "-fsanitize=undefined")

	set(_cmake_base_sanitizer_tsan_compiler_flags "-fsanitize=thread")
	set(_cmake_base_sanitizer_tsan_linker_flags "-fsanitize=thread")

	set(_cmake_base_sanitizer_aux_compiler_flags "-fno-omit-frame-pointer")
	set(_cmake_base_sanitizer_aux_linker_flags "")

elseif(_cmake_base_build_compiler STREQUAL "llvm-clang" AND _cmake_base_target_os STREQUAL "linux")
	set(_cmake_base_sanitizer_family "linux-llvm-clang")

	set(_cmake_base_sanitizer_asan_compiler_flags "-fsanitize=address")
	set(_cmake_base_sanitizer_asan_linker_flags "-fsanitize=address")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "-fsanitize=undefined")
	set(_cmake_base_sanitizer_ubsan_linker_flags "-fsanitize=undefined")

	set(_cmake_base_sanitizer_tsan_compiler_flags "-fsanitize=thread")
	set(_cmake_base_sanitizer_tsan_linker_flags "-fsanitize=thread")

	set(_cmake_base_sanitizer_aux_compiler_flags "-fno-omit-frame-pointer")
	set(_cmake_base_sanitizer_aux_linker_flags "")

elseif(_cmake_base_build_compiler STREQUAL "llvm-clang" AND _cmake_base_target_os STREQUAL "windows")
	set(_cmake_base_sanitizer_family "windows-llvm-clang")

	set(_cmake_base_sanitizer_asan_compiler_flags "-fsanitize=address")
	set(_cmake_base_sanitizer_asan_linker_flags "-fsanitize=address")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "-fsanitize=undefined")
	set(_cmake_base_sanitizer_ubsan_linker_flags "-fsanitize=undefined")

	set(_cmake_base_sanitizer_tsan_compiler_flags "")
	set(_cmake_base_sanitizer_tsan_linker_flags "")

	set(_cmake_base_sanitizer_aux_compiler_flags "-fno-omit-frame-pointer")
	set(_cmake_base_sanitizer_aux_linker_flags "")

elseif(_cmake_base_build_compiler STREQUAL "clang-cl" AND _cmake_base_target_os STREQUAL "windows")
	set(_cmake_base_sanitizer_family "windows-clang-cl-unsupported")

	set(_cmake_base_sanitizer_asan_compiler_flags "")
	set(_cmake_base_sanitizer_asan_linker_flags "")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "")
	set(_cmake_base_sanitizer_ubsan_linker_flags "")

	set(_cmake_base_sanitizer_tsan_compiler_flags "")
	set(_cmake_base_sanitizer_tsan_linker_flags "")

	set(_cmake_base_sanitizer_aux_compiler_flags "")
	set(_cmake_base_sanitizer_aux_linker_flags "")

elseif(_cmake_base_build_compiler STREQUAL "mingw-w64-gcc" AND _cmake_base_target_os STREQUAL "windows")
	set(_cmake_base_sanitizer_family "windows-mingw-w64-gcc-unsupported")

	set(_cmake_base_sanitizer_asan_compiler_flags "")
	set(_cmake_base_sanitizer_asan_linker_flags "")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "")
	set(_cmake_base_sanitizer_ubsan_linker_flags "")

	set(_cmake_base_sanitizer_tsan_compiler_flags "")
	set(_cmake_base_sanitizer_tsan_linker_flags "")

	set(_cmake_base_sanitizer_aux_compiler_flags "")
	set(_cmake_base_sanitizer_aux_linker_flags "")

elseif(_cmake_base_build_compiler STREQUAL "mingw32-gcc" AND _cmake_base_target_os STREQUAL "windows")
	set(_cmake_base_sanitizer_family "windows-mingw32-gcc-unsupported")

	set(_cmake_base_sanitizer_asan_compiler_flags "")
	set(_cmake_base_sanitizer_asan_linker_flags "")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "")
	set(_cmake_base_sanitizer_ubsan_linker_flags "")

	set(_cmake_base_sanitizer_tsan_compiler_flags "")
	set(_cmake_base_sanitizer_tsan_linker_flags "")

	set(_cmake_base_sanitizer_aux_compiler_flags "")
	set(_cmake_base_sanitizer_aux_linker_flags "")

elseif(_cmake_base_build_compiler STREQUAL "msvc" AND _cmake_base_target_os STREQUAL "windows" AND MSVC_VERSION GREATER_EQUAL 1928)
	set(_cmake_base_sanitizer_family "windows-msvc")

	set(_cmake_base_sanitizer_asan_compiler_flags "/fsanitize=address")
	set(_cmake_base_sanitizer_asan_linker_flags "/fsanitize=address")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "")
	set(_cmake_base_sanitizer_ubsan_linker_flags "")

	set(_cmake_base_sanitizer_tsan_compiler_flags "")
	set(_cmake_base_sanitizer_tsan_linker_flags "")

	set(_cmake_base_sanitizer_aux_compiler_flags "")
	set(_cmake_base_sanitizer_aux_linker_flags "/INCREMENTAL:NO")

elseif(_cmake_base_build_compiler STREQUAL "apple-clang" AND _cmake_base_target_os STREQUAL "darwin")
	set(_cmake_base_sanitizer_family "darwin-apple-clang")

	set(_cmake_base_sanitizer_asan_compiler_flags "-fsanitize=address")
	set(_cmake_base_sanitizer_asan_linker_flags "-fsanitize=address")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "-fsanitize=undefined")
	set(_cmake_base_sanitizer_ubsan_linker_flags "-fsanitize=undefined")

	set(_cmake_base_sanitizer_tsan_compiler_flags "-fsanitize=thread")
	set(_cmake_base_sanitizer_tsan_linker_flags "-fsanitize=thread")

	set(_cmake_base_sanitizer_aux_compiler_flags "-fno-omit-frame-pointer")
	set(_cmake_base_sanitizer_aux_linker_flags "")

else()
	set(_cmake_base_sanitizer_family "unsupported")

	set(_cmake_base_sanitizer_asan_compiler_flags "")
	set(_cmake_base_sanitizer_asan_linker_flags "")

	set(_cmake_base_sanitizer_ubsan_compiler_flags "")
	set(_cmake_base_sanitizer_ubsan_linker_flags "")

	set(_cmake_base_sanitizer_tsan_compiler_flags "")
	set(_cmake_base_sanitizer_tsan_linker_flags "")

	set(_cmake_base_sanitizer_aux_compiler_flags "")
	set(_cmake_base_sanitizer_aux_linker_flags "")

endif()

function(_cmake_base_sanitizer_compiler_flags name outval)
	if(name STREQUAL "ASAN")
		set("${outval}" "${_cmake_base_sanitizer_asan_compiler_flags}" PARENT_SCOPE)
	elseif(name STREQUAL "UBSAN")
		set("${outval}" "${_cmake_base_sanitizer_ubsan_compiler_flags}" PARENT_SCOPE)
	elseif(name STREQUAL "TSAN")
		set("${outval}" "${_cmake_base_sanitizer_tsan_compiler_flags}" PARENT_SCOPE)
	else()
		set("${outval}" "" PARENT_SCOPE)
	endif()
endfunction()

function(_cmake_base_sanitizer_linker_flags name outval)
	if(name STREQUAL "ASAN")
		set("${outval}" "${_cmake_base_sanitizer_asan_linker_flags}" PARENT_SCOPE)
	elseif(name STREQUAL "UBSAN")
		set("${outval}" "${_cmake_base_sanitizer_ubsan_linker_flags}" PARENT_SCOPE)
	elseif(name STREQUAL "TSAN")
		set("${outval}" "${_cmake_base_sanitizer_tsan_linker_flags}" PARENT_SCOPE)
	else()
		set("${outval}" "" PARENT_SCOPE)
	endif()
endfunction()

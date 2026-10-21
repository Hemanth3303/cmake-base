include_guard()

function(cmake_base_configure_target target)
	if(NOT TARGET "${target}")
		message(
			FATAL_ERROR
			"cmake_base_configure_target: target '${target}' does not exist"
		)
	endif()

	target_compile_definitions("${target}"
		PRIVATE
			"$<$<CONFIG:Debug>:DEBUG>"
			"$<$<CONFIG:Profile>:NDEBUG>"
			"$<$<CONFIG:Release>:NDEBUG>"
	)

	if(_cmake_base_target_os STREQUAL "windows")
		target_compile_definitions(
			"${target}"
			PRIVATE
				NOMINMAX
				_CRT_SECURE_NO_WARNINGS
				WIN32_LEAN_AND_MEAN
		)

		if(_cmake_base_build_compiler STREQUAL "msvc")
			target_compile_definitions(
				"${target}"
				PRIVATE
					/Zc:__cplusplus
					/Zc:preprocessor
					/EHsc
			)
		elseif(_cmake_base_build_compiler STREQUAL "mingw-w64-gcc" OR _cmake_base_build_compiler STREQUAL "mingw32-gcc")
			target_link_libraries(
				"${target}"
				PUBLIC
					m
			)
			target_link_options(
				"${target}"
				PRIVATE
					-static
					-static-libgcc
					-static-libstdc++
			)
		elseif(_cmake_base_build_compiler STREQUAL "llvm-clang")
			target_link_options(
				"${target}"
				PRIVATE
					-static
			)
		endif()

	elseif(_cmake_base_target_os STREQUAL "linux")
		if(_cmake_base_build_compiler STREQUAL "gnu-gcc")
			target_link_libraries(
				"${target}"
				PUBLIC
					m
					dl
					pthread
			)
		endif()

	endif()
endfunction()

function(cmake_base_apply_target_definitions target prefix)
	if(NOT TARGET "${target}")
		message(
			FATAL_ERROR
			"cmake_base_configure_target: target '${target}' does not exist"
		)
	endif()

	if(NOT prefix MATCHES "^[A-Za-z_][A-Za-z0-9_]*$")
		message(
			FATAL_ERROR
			"cmake_base_configure_target: invalid prefix '${prefix}' (need C identifier stem)"
		)
	endif()

	target_compile_definitions(
		"${target}"
		PRIVATE
			"${prefix}"
			"$<$<CONFIG:Debug>:${prefix}_DEBUG_BUILD>"
			"$<$<CONFIG:Profile>:${prefix}_PROFILE_BUILD>"
			"$<$<CONFIG:Release>:${prefix}_RELEASE_BUILD>"
	)
endfunction()


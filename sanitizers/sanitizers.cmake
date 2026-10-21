# Configure ASAN, UBSAN, TSAN

include_guard()

if(NOT CMAKE_BASE_CONFIGS)
	message(
		FATAL_ERROR
		"cmake_base: CMAKE_BASE_CONFIGS must be set before including sanitizers.cmake"
	)
endif()

set(_cmake_base_known_sanitizers ASAN UBSAN TSAN)
set(_cmake_base_warned_and_unsupported_sanitizers_list "")

include("${CMAKE_CURRENT_LIST_DIR}/sanitizer_support_flags_table.cmake" REQUIRED)

# ----- INTERNAL HELPERS ----- #

function(_cmake_base_sanitizer_is_supported name outval)
	_cmake_base_sanitizer_compiler_flags("${name}" _compile_flags)
	if(_compile_flags)
		set("${outval}" TRUE PARENT_SCOPE)
	else()
		set("${outval}" FALSE PARENT_SCOPE)
	endif()
endfunction()

function(_cmake_base_warn_unsupported_sanitizer name)
	if(name IN_LIST _cmake_base_warned_and_unsupported_sanitizers_list)
		return()
	endif()
	list(APPEND _cmake_base_warned_and_unsupported_sanitizers_list "${name}")
	set(_cmake_base_warned_and_unsupported_sanitizers_list "${_cmake_base_warned_and_unsupported_sanitizers_list}" PARENT_SCOPE)
	message(
		WARNING
		"cmake-base: ${_cmake_base_build_compiler} does not support ${name}"
	)
endfunction()

function(_cmake_base_warn_duplicate_sanitizer name)
	message(
		WARNING
		"cmake-base: duplicate sanitizer '${name}' in sanitizers list;"
		"using once"
	)
endfunction()

function(_cmake_base_check_sanitizer_compatibility sanitizer_list)
	set(_has_asan FALSE)
	set(_has_ubsan FALSE)
	set(_has_tsan FALSE)

	foreach(_sanitizer in LISTS sanitizer_list)
		if(_sanitizer STREQUAL "ASAN")
			set(_has_asan TRUE)
		elseif(_sanitizer STREQUAL "UBSAN")
			set(_has_ubsan TRUE)
		elseif(_sanitizer STREQUAL "TSAN")
			set(_has_tsan TRUE)
		endif()
	endforeach()

	if(_has_asan AND _has_tsan)
		message(
			FATAL_ERROR
			"cmake-base: ASAN AND TSAN are incompatible"
		)
	endif()

	if(_has_ubsan AND _has_tsan)
		message(
			FATAL_ERROR
			"cmake-base: UBSAN and TSAN are incompatible"
		)
	endif()
endfunction()

function(_cmake_base_sanitizer_get_property_key config outval)
	set("${outval}" "_cmake_base_sanitizers_config_${config}" PARENT_SCOPE)
endfunction()

function(_cmake_base_sanitizer_get_aux_property_key config outval)
	set("${outval}" "_cmake_base_sanitizers_aux_config_${config}" PARENT_SCOPE)
endfunction()

function(_cmake_base_merge_sanitizer_sets old_list new_list outval)
	set(_merged "${old_list}")

	foreach(_sanitizer IN LISTS new_list)
		if((NOT _sanitizer IN_LIST _merged))
			list(APPEND _merged "${_sanitizer}")
		endif()
	endforeach()

	list(SORT _merged)
	set("${outval}" "${_merged}" PARENT_SCOPE)

endfunction()

function(_cmake_base_sanitizer_sets_are_equal left right outval)
	if("${left}" STREQUAL "${right}")
		set("${outval}" TRUE PARENT_SCOPE)
	else()
		set("${outval}" FALSE PARENT_SCOPE)
	endif()
endfunction()

function(_cmake_base_apply_aux_flags_for_config target config sanitizer_list)
	if(NOT sanitizer_list)
		return()
	endif()

	_cmake_base_sanitizer_get_aux_property_key("${config}" _aux_key)
	get_target_property(_existing "${target}" "${_aux_key}")
	if(_existing)
		return()
	endif()

	if(_cmake_base_sanitizer_aux_compiler_flags)
		target_compile_options(
			"${target}"
			PRIVATE
			"$<$<CONFIG:${config}>:${_cmake_base_sanitizer_aux_compiler_flags}>"
		)
	endif()

	if(_cmake_base_sanitizer_aux_linker_flags)
		target_link_options(
			"${target}"
			PRIVATE
			"$<$<CONFIG:${config}>:${_cmake_base_sanitizer_aux_linker_flags}>"
		)
	endif()

	set_target_properties("${target}" PROPERTIES "${_aux_key}" TRUE)
endfunction()

function(_cmake_base_sanitizer_apply_delta_for_config target config delta_list)
	foreach(_sanitizer IN LISTS delta_list)
		_cmake_base_sanitizer_compiler_flags("${_sanitizer}" _compiler_flags)
		_cmake_base_sanitizer_linker_flags("${_sanitizer}" _linker_flags)

		if(_compiler_flags)
			target_compile_options(
				"${target}"
				PRIVATE
				"$<$<CONFIG:${config}>:${_compiler_flags}>"
			)
		endif()

		if(_linker_flags)
			target_link_options(
				"${target}"
				PRIVATE
				"$<$<CONFIG:${config}>:${_linker_flags}>"
			)
		endif()
	endforeach()
endfunction()

function(_cmake_base_apply_sanitizers_for_config target config supported_sanitizers)
	if(NOT supported_sanitizers)
		return()
	endif()

	_cmake_base_sanitizer_get_property_key("${config}" _property_key)
	get_target_property(_existing "${target}" "${_property_key}")
	if(NOT _existing OR _existing STREQUAL "_existing-NOTFOUND")
		set(_existing "")
	endif()
	if(_existing)
		list(SORT _existing)
	endif()

	_cmake_base_merge_sanitizer_sets("${_existing}" "${supported_sanitizers}" _merged)
	_cmake_base_sanitizer_sets_are_equal("${_merged}" "${_existing}" _unchanged)
	if(_unchanged)
		return()
	endif()

	_cmake_base_check_sanitizer_compatibility("${_merged}")

	set(_delta "${supported_sanitizers}")

	if(_existing)
		foreach(_sanitizer IN LISTS _existing)
			list(REMOVE_ITEM _delta "${_sanitizer}")
		endforeach()
	endif()

	if(NOT _existing)
		_cmake_base_apply_aux_flags_for_config(
			"${target}"
			"${config}"
			"${_merged}"
		)
	endif()

	if(_delta)
		_cmake_base_sanitizer_apply_delta_for_config(
			"${target}"
			"${config}"
			"${_delta}"
		)
	endif()

	set_target_properties("${target}" PROPERTIES "${_property_key}" "${_merged}")
endfunction()

# ----- PUBLIC API ----- #

function(cmake_base_apply_sanitizers target)
	set(_options "")
	set(_one_value "")
	set(_multi_value SANITIZERS CONFIGS)
	cmake_parse_arguments(_ARG "${_options}" "${_one_value}" "${_multi_value}" "${ARGN}")

	if(NOT _ARG_SANITIZERS)
		message(
			FATAL_ERROR
			"cmake_base_apply_sanitizers: SANITIZERS is required"
		)
	endif()

	if(NOT _ARG_CONFIGS)
		message(
			FATAL_ERROR
			"cmake_base_apply_sanitizers: CONFIGS is required"
		)
	endif()

	if(NOT TARGET "${target}")
		message(
			FATAL_ERROR
			"cmake_base_apply_sanitizers: target '${target}' does not exist"
		)
	endif()

	set(_deduped_sanitizers "")
	foreach(_sanitizer IN LISTS _ARG_SANITIZERS)
		if(_sanitizer IN_LIST _deduped_sanitizers)
			_cmake_base_warn_duplicate_sanitizer("${_sanitizer}")
			continue()
		endif()

		if(NOT _sanitizer IN_LIST _cmake_base_known_sanitizers)
			message(
				FATAL_ERROR
				"cmake_base_apply_sanitizers: unknown sanitizer '${_sanitizer}'"
			)
		endif()

		list(APPEND _deduped_sanitizers "${_sanitizer}")

	endforeach()

	set(_supported_sanitizers "")
	foreach(_sanitizer IN LISTS _deduped_sanitizers)
		_cmake_base_sanitizer_is_supported("${_sanitizer}" _is_supported)
		if(_is_supported)
			list(APPEND _supported_sanitizers "${_sanitizer}")
		else()
			_cmake_base_warn_unsupported_sanitizer("${_sanitizer}")
		endif()
	endforeach()

	foreach(_config IN LISTS _ARG_CONFIGS)
		if(NOT _config IN_LIST CMAKE_BASE_CONFIGS)
			message(
				FATAL_ERROR
				"cmake_base_apply_sanitizers: unknown config '${_config}'"
			)
		endif()
	endforeach()

	if(_supported_sanitizers)
		_cmake_base_check_sanitizer_compatibility("${_supported_sanitizers}")
	endif()

	foreach(_config IN LISTS _ARG_CONFIGS)
		_cmake_base_apply_sanitizers_for_config("${target}" "${_config}" "${_supported_sanitizers}")
	endforeach()

endfunction()

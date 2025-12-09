# example
# set(MY_VAR "hi")
# print(PROJECT_NAME PROJECT_NAME_FOO MY_VAR)
function(print)
	foreach(var ${ARGN})
		message("${var} = ${${var}}")
	endforeach()
endfunction(print)

# example
# print_env(PATH)
function(print_env)
	foreach(var ${ARGN})
		message("${var} = $ENV{${var}}")
	endforeach()
endfunction(print_env)
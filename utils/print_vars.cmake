# To print cmake variables
#
# example
# set(MY_VAR "hi")
# print_var(PROJECT_NAME PROJECT_NAME_FOO MY_VAR)
function(print_var)
	foreach(var ${ARGN})
		message("${var} = ${${var}}")
	endforeach()
endfunction(print)

# To print environment variables like PATH
#
# example
# print_env_var(PATH)
function(print_env_var)
	foreach(var ${ARGN})
		message("${var} = $ENV{${var}}")
	endforeach()
endfunction(print_env)

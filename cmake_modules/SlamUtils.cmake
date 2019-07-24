function(status msg)
    message(STATUS ${msg})
endfunction()

function(status_list msg lst)
    set(INDEX 1)
    #cmake_parse_arguments(ARG "" "" "" ARG_ALL)
    math(EXPR MAX "${ARGC}-1")
    foreach(idx RANGE ${INDEX} ${MAX})
        set(ARG_ALL "${ARG_ALL} ${ARGV${idx}};")
    endforeach()
    message(STATUS "${msg}${ARG_ALL}")
endfunction()

# Debugging function
function(slam_cmake_dump_vars)
    set(SLAM_SUPPRESS_DEPRECATIONS 1)  # suppress deprecation warnings from variable_watch() guards
    get_cmake_property(__variableNames VARIABLES)
    cmake_parse_arguments(DUMP "" "TOFILE" "" ${ARGN})
    set(regex "${DUMP_UNPARSED_ARGUMENTS}")
    string(TOLOWER "${regex}" regex_lower)
    set(__VARS "")
    foreach(__variableName ${__variableNames})
        string(TOLOWER "${__variableName}" __variableName_lower)
        if((__variableName MATCHES "${regex}" OR __variableName_lower MATCHES "${regex_lower}")
                AND NOT __variableName_lower MATCHES "^__")
            set(__VARS "${__VARS}${__variableName}=${${__variableName}}\n")
        endif()
    endforeach()
    if(DUMP_TOFILE)
        file(WRITE ${CMAKE_BINARY_DIR}/${DUMP_TOFILE} "${__VARS}")
    else()
        message(AUTHOR_WARNING "${__VARS}")
    endif()
endfunction()

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
execute_process(COMMAND "date /t" OUTPUT_VARIABLE TIME_CURRENT)
else()
execute_process(COMMAND date OUTPUT_VARIABLE TIME_CURRENT)
endif()
string(REPLACE "\n" "" CMAKE_CURRENT_TIME ${TIME_CURRENT})
#!/usr/bin/env bash

##############################################################################
# PHP lint script                                                            #
# This script checks your PHP files for syntax errors.                       #
# @author Martin Mitterhauser                                                #
# @author Gregor J.                                                          #
##############################################################################

##
# Set internal variables.
##
LINT_RESULT=0
LINT_EXT=("*.php")
LINT_OUT=/dev/null

##
# Print usage information.
##
function show_usage() {
    echo -n "Usage: phplint.sh"
    echo -n -e " \e[0;32m[options]\e[0m"
    echo -e " \e[0;34m<directory>\e[0m [\e[0;34m<directory>\e[0m ...]\e[0m"
}

##
# Print help and usage information.
##
function show_help() {
    echo "This script checks the PHP files of the given directories for syntax errors."
    echo
    show_usage
    echo
    echo "Parameters:"
    echo -n -e "  \e[0;34m<directory>\e[0m"
    echo "  The directory/directories to search for PHP files."
    echo
    echo "Options:"
    echo -n -e "  \e[0;32m-e\e[0m \e[0;34m<ext>\e[0m | \e[0;32m--extension\e[0m \e[0;34m<ext>\e[0m"
    echo "  Define PHP files extension other than *.php to lint."
    echo -n -e "  \e[0;32m-v\e[0m       | \e[0;32m--verbose\e[0m"
    echo "          Print positive lint results too."
    echo -n -e "  \e[0;32m-h\e[0m       | \e[0;32m--help\e[0m"
    echo "             Show this help."
    echo
}

# Define an array of directories to process.
declare -a LINT_DIR

# Analyze each parameter/option of this call.
while [ "${1}" ]; do
    case "${1}" in
        -h | --help )
            show_help
            exit 1
            ;;
        -v | --verbose )
            LINT_OUT=/dev/stdout
            shift
            ;;
        -e | --extension )
            shift
            if [ -z "${1}" ]; then
                (>&2 echo -e "\e[0;31mExtension missing!\e[0m")
                LINT_RESULT=2
                continue
            fi
            # Add extension to array of extensions.
            LINT_EXT+=("${1}")
            shift
            ;;
        * )
            # This might be a directory, so treat it like one.
            if [ ! -d "${1}" ]; then
                (>&2 echo -e "\e[0;31mCannot find directory\e[0m \e[0;34m${1}\e[0;31m!\e[0m")
                LINT_RESULT=2
                shift
                continue
            fi
            # Add directory to array of directories.
            LINT_DIR+=("${1}")
            shift
            ;;
    esac
done

# In case there were unknown directories
if [ ${LINT_RESULT} != 0 ]; then
    exit ${LINT_RESULT}
fi

# Run `php -l` for each file matching each extension found in each directory.
for dir in "${LINT_DIR[@]}"; do
    for ext in "${LINT_EXT[@]}"; do
        for file in $(find "${dir}" -type f -name "${ext}") ; do
            php -l "${file}" > ${LINT_OUT} || LINT_RESULT=3
        done
    done
done

# Print the positive or negative result.
if [ ${LINT_RESULT} != 0 ]; then
    echo -e "\e[0;31mThere were syntax errors!\e[0m"
else
    echo -e "\e[0;32mThere were no syntax errors!\e[0m"
fi

exit ${LINT_RESULT}

#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# General notes:
#   @todo: Rewrite this implementation without use eval command

# @todo: Rewrite to parse result set command `set | grep "${arr_name}" ...`
get_val_by_name () {
  local arr_name="${1}"

  is_input_empty=$( [ -z "${arr_name}" ] &&\
                    echo true || echo false )
  if [ "${is_input_empty}" = "true" ]; then
    # One or both arguments are empty
    return 1
  fi

  eval "echo \"\${${arr_name}}\""

  return 0
}

# @todo: Rewrite to export command `export "${arr_name}"=value`
set_by_name () {
  local arr_name="${1}"
  local new_value="${2}"

  is_input_empty=$( { [ -z "${arr_name}" ] ||\
                      [ -z "${new_value}" ]; } &&\
                    echo true || echo false )
  if [ "${is_input_empty}" = "true" ]; then
    # One or both arguments are empty
    return 1
  fi

  eval "${arr_name}=\"${new_value}\""

  return 0
}

# All last ne lines and spaces will be lost
#   - this is normal behaviour for POSIX shell
add_to_end () {
  local arr_name="${1}"
  local value="${2}"
  local array_val=''
  local new_elem=''
  local new_val=''

  is_input_empty=$( { [ -z "${arr_name}" ] ||\
                      [ -z "${value}" ]; } &&\
                    echo true || echo false )
  if [ "${is_input_empty}" = "true" ]; then
    # One or both arguments are empty
    return 1
  fi


  array_val=$(get_val_by_name "${arr_name}")
  # new_elem printf need for interpr spec symbols like '\n' (without last)
  new_elem="$(printf '%b' "${value}")"
  new_val="${array_val}${new_elem}"
  set_by_name "${arr_name}" "${new_val}"

  return 0
}
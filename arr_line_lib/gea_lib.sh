#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_GEA_LIB_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_GEA_LIB_DIR}/var_lib.sh"
# shellcheck disable=SC1091
. "${_GEA_LIB_DIR}/text_lib.sh"

# Создание нового "массива"
new_array() {
  eval "$1=\"\""

  return 0
}

# rec_delim - record_delimeter
add_elem() {
  local arr_name="$1"
  local value="$2"
  local array_val=''
  local is_array_empty='true'
  local rec_delim=''
  local new_record=''

  array_val="$(get_val_by_name "${arr_name}")"
  # Check if array empty or key already exists
  # Set new line if needed
  rec_delim='\n'
  is_array_empty=$( [ -z "${array_val}" ] && echo true || echo false )
  if [ "${is_array_empty}" = "true" ]; then
    rec_delim=''
  fi
  new_record="${rec_delim}${value}"
  add_to_end "${arr_name}" "${new_record}"

  return 0
}

# Получение элемента из "массива" по индексу
# line_num - The line number to extract
get_elem() {
  local arr_name="$1"
  local elem_idx="$2"
  local line_num=0
  local line_val=''

  line_num=$(( elem_idx + 1))
  line_val="$(get_line_val "${arr_name}" "${line_num}")"
  echo "${line_val}"

  return 0
}

# Удаление элемента из "массива" по индексу
# line_num - The line number to extract
del_elem() {
  local arr_name="$1"
  local index="$2"
  local line_num=0

  line_num=$(( index + 1))
  del_line_by_num "${arr_name}" "${line_num}"

  return 0
}

get_arr_size () {
  local arr_name="$1"

  get_count_lines "${arr_name}"

  return 0
}
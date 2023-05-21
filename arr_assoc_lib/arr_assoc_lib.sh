#!/bin/bash -i

# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Associative Array Library for ash or bash

# Limitations:
# - Array keys and values should not contain spaces or newlines.
# - Array names should not contain spaces, newlines, or any special characters.
# - This library doesn't support bash-specific syntax.

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_ARR_ASSOC_LIB_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_ARR_ASSOC_LIB_DIR}/../src/var_lib.sh"
# shellcheck disable=SC1091
. "${_ARR_ASSOC_LIB_DIR}/../src/gea_lib.sh"

cfg_separator_fields=" "

get_idx() {
  local arr_name="$1"
  local key="$2"
  local arr_val
  local idx=0
  local line
  
  arr_val="$(get_val_by_name "${arr_name}")"
  while IFS=' ' read -r line; do
      if [ "${line%% *}" = "${key}" ]; then
          echo ${idx}
          return 0
      fi
      idx=$((idx + 1))
  done <<EOF
${arr_val}
EOF
  echo -1

  return 1
}

extract_val_from_elem() {
  local input_string="${1}" # Входная строка
  local value=""

  value=$(echo "${input_string}" | awk -F"${cfg_separator_fields}" '{print $2}')
  echo "${value}"

  return 0
}

replace_line_in_arr () {
  local arr_name="${1}"
  local search="${2}"
  local replace="${3}"
  local arr_val

  arr_val="$(get_val_by_name "${arr_name}")"
  # Replace line
  arr_val="$(echo "${arr_val}" | sed "s/${search}/${replace}/g")"
  # Reassigning a variable in the parent shell
  set_by_name "${arr_name}" "${arr_val}"

  return 0
}

# get_arr_size - see gea_lib.sh
# get_arr_size() {
# }


# - Get array value by array variable name
# ...
# - Add new element to array by array variable name
add_pair() {
  local arr_name="$1"
  local key="$2"
  local value="$3"
  local idx_elem
  local is_elem_exists
  local new_elem

  idx_elem=$(get_idx "${arr_name}" "${key}")
  is_elem_exists=$( [ "${idx_elem}" -ne -1 ] && echo true || echo false )
  if [ "${is_elem_exists}" = "true" ]; then
    echo "Error: Key already exists."
    return 1
  fi
  new_elem="${key} ${value}"

  add_elem "${arr_name}" "${new_elem}"

  return 0
}

del_key() {
  local arr_name="$1"
  local key="$2"
  local deleted_index

  deleted_index=$(get_idx "${arr_name}" "${key}")
  if [ "${deleted_index}" -ge 0 ]; then
      del_elem "${arr_name}" "${deleted_index}"
  fi

  return 0
}

get_val() {
  local arr_name="${1}"
  local key="${2}"
  local arr_val
  local line

  arr_val="$(get_val_by_name "${arr_name}")"
  while IFS= read -r line; do
      if [ "${line%% *}" = "${key}" ]; then
          echo "${line#* }"
          return 0
      fi
  done <<EOF
${arr_val}
EOF
  echo "Error: Key not found."

  return 1
}


# Function updates the value of an array element if it exists.
# The update is done in the old place - index (line number) does not chang.
# - Find index
# - Get element data (key+old_value) by index
# - Replace "key+old_value" to "key+new_value"
upd_val() {
  local arr_name="${1}"
  local key="${2}"
  local new_value="${3}"
  local idx
  local search_line
  local new_line

  idx=$(get_idx "${arr_name}" "${key}")
  new_line="${key}${cfg_separator_fields}${new_value}"
  if [ "${idx}" -ne -1 ]; then
    search_line=$(get_elem "${arr_name}" "${idx}")
    replace_line_in_arr "${arr_name}" "${search_line}" "${new_line}"
  else
      echo "Error: Key not found."
      return 1
  fi

  return 0
}
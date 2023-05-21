#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_TEXT_LIB_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_TEXT_LIB_DIR}/var_lib.sh"

# var_name - The multiline variable
# line_num - The line number to extract (from 1 to ...) 
get_line_val() {
  local var_name="${1}"
  local line_num="${2}"
  local var_val=''

  var_val="$(get_val_by_name "${var_name}")"
  if [ "${line_num}" -ge 0 ]; then
    # This variant faster instead this: sed -n "${line_num}p"
    echo "${var_val}" | sed "${line_num}q;d"
  fi

  return 0
}

get_count_lines() {
  local var_name="${1}"
  local var_val=''
  local is_arr_not_empty=''
  local newline_count=0
  local bytes_count=0
  local line_count=0

  var_val="$(get_val_by_name "${var_name}")"
  newline_count=$(echo -n "${var_val}" | wc -l | tr -d '\n')
  bytes_count=$(echo -n "${var_val}" | wc -c | tr -d '\n')
  is_arr_not_empty=$( [ "${bytes_count}" -ge 1 ] && echo true || echo false )
  if [ "${is_arr_not_empty}" = "true" ]; then
    # "wc -l" count only new lines - not real lines -> we need add +1
    line_count=$(( newline_count + 1 ))
  fi
  echo -n "${line_count}"

  return 0
}

# @todo: rewrite to while
# get_array_size() {
#   local array_name="$1"
#   local array
#   local size=0
#   local line

#   array="$(eval "echo \"\$${array_name}\"")"
#   while IFS= read -r line; do
#       size=$((size + 1))
#   done <<EOF
# ${array}
# EOF

#   echo ${size}
# }


del_line_by_num() {
  local var_name="${1}"
  local line_num="${2}" # The line number to extract
  local var_val=''
  local line_count=0
  local is_valid_line='true'
  local new_value=''

  var_val="$(get_val_by_name "${var_name}")"
  line_count="$(get_count_lines "${var_name}")"
  is_valid_line=$( { [ "${line_num}" -ge 1 ] &&\
                      [ "${line_num}" -le "${line_count}" ]; } &&\
                    echo true || echo false )
  if [ "${is_valid_line}" = "true" ]; then
    new_value=$(echo "${var_val}" | sed "${line_num}d")
    set_by_name "${var_name}" "${new_value}"
  else
    echo "Invalid line num: ${line_num}"
    return 1
  fi

  return 0
}
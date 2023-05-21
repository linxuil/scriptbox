#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else echo nbash; _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_ASARR_EX_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_ASARR_EX_DIR}/../arr_assoc_lib.sh"

main () {
  local my_array1=""
  local val_upd_key2
  local size_after_del

  echo "= = Create an associative array = ="
  echo '- Create 3 keys...'
  add_pair "my_array1" "key1" "value1"
  add_pair "my_array1" "key2" "value2"
  add_pair "my_array1" "key3" "value3"
  echo '- Show array:'
  echo "${my_array1}"
  echo

  echo "= = Display the size of the array = ="
  echo "Size of the array: $(get_arr_size "my_array1")"
  echo

  echo "= = Get a value from the array = ="
  echo "Value for key2: $(get_val "my_array1" "key2")"
  echo

  echo "= = Update a value in the array = ="
  upd_val "my_array1" "key2" "new_value2"
  val_upd_key2=$(get_val "my_array1" "key2")
  echo "Updated value for key2: '${val_upd_key2}'"
  echo '- Show actual array:'
  echo "${my_array1}"
  echo

  echo "= = Delete an element from the array = ="
  del_elem "my_array1" "key1"
  size_after_del=$(get_arr_size "my_array1")
  echo "Size of the array after deletion: '${size_after_del}'"
  echo '- Show actual array:'
  echo "${my_array1}"
}

main
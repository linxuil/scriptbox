#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_TEST_GEA_LIB_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_TEST_GEA_LIB_DIR}/sts_helpers.sh"
# shellcheck disable=SC1091
. "${_TEST_GEA_LIB_DIR}/../src/gea_lib.sh"

test_new_array() {
  local test_array=''

  new_array "test_array"
  echo "Array:'${new_array}'"
  test_array_size=$(get_arr_size "test_array")
  sts_assert_equal "0" "$test_array_size"
}

test_add_elem() {
  local test_array=''

  add_elem "test_array" "value0"
  test_array_size=$(get_arr_size "test_array")
  sts_assert_equal "1" "$test_array_size"
  test_array_value=$(get_elem "test_array" "0")
  sts_assert_equal "value0" "$test_array_value"
}

test_get_elem() {
  local test_array=''

  add_elem "test_array" "value0"
  test_array_value=$(get_elem "test_array" "0")
  sts_assert_equal "value0" "$test_array_value"
}

test_del_elem() {
  local test_array=''

  add_elem "test_array" "value0"
  add_elem "test_array" "value1"
  del_elem "test_array" "0"
  test_array_size=$(get_arr_size "test_array")
  sts_assert_equal "1" "$test_array_size"
  test_array_value=$(get_elem "test_array" "0")
  sts_assert_equal "value1" "$test_array_value"
}
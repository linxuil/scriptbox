#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_TEST_ASA_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_TEST_ASA_DIR}/../../sts/sts_helpers.sh"
# shellcheck disable=SC1091
. "${_TEST_ASA_DIR}/../arr_assoc_lib.sh"

# Test associative array functions
test_get_arr_size() {
  local array=''
  local array_size=0
  local rc=0

  array="key1 value1
key2 value2
key3 value3"
  array_size=$(get_arr_size "array")
  rc=$?

  sts_assert_equal "3" "${array_size}"
  sts_assert_equal "0" "${rc}"
  echo "Array content:"
  echo "${array}"
}

test_get_val() {
  local array=''
  local val=''
  local rc=0


  array="key1 value1
key2 value2
key3 value3"
  val=$(get_val "array" "key2")
  rc=$?

  sts_assert_equal "value2" "${val}"
  sts_assert_equal "0" "${rc}"
  echo "Array content:"
  echo "${array}"
}

# Test associative array functions
test_add_pair_to_existing_array() {
    local array=''
    local rc=0
    local arr_size=0
    
    array="key1 value1
key2 value2"
    add_pair array "key3" "value3"
    rc=$?
    arr_size=$(get_arr_size "array")
    sts_assert_equal "3" "${arr_size}"
    sts_assert_equal "0" "${rc}"
}

test_add_pair_to_empty_array() {
    local array=""
    local add1_rc=0
    local add2_rc=0
    local add3_rc=0
    local arr_size=0

    add_pair "array" "key1" "value1"
    add1_rc=$?
    add_pair "array" "key2" "value2"
    add2_rc=$?
    add_pair "array" "key3" "value3"
    add3_rc=$?
  
    arr_size=$(get_arr_size "array")
    sts_assert_equal "3" "${arr_size}"
    sts_assert_equal "0" "${add1_rc}"
    sts_assert_equal "0" "${add2_rc}"
    sts_assert_equal "0" "${add3_rc}"
}

test_add_pair_failure() {
    local array="key1 value1
key2 value2
key3 value3"
    add_pair "array" "key1" "value4" > /dev/null 2>&1
    local return_code=$?
    sts_assert_equal "1" "${return_code}"
}

test_del_key() {
    local array="key1 value1
key2 value2
key3 value3"
    del_key "array" "key2"
    local del_rc=$?
    local expected_array="key1 value1
key3 value3"
    sts_assert_equal "${expected_array}" "${array}"
    sts_assert_equal "0" "${del_rc}"
}

test_extract_val_from_elem() {
    local rc

    # Тест 1: Строка с разделителем " "
    input="key value"
    expected="value"
    rc=$?
    val1="$(extract_val_from_elem "${input}")"
    sts_assert_equal "${expected}" "${val1}"
    sts_assert_equal "0" "${rc}"

    # Тест 2: Строка с не верным разделителем "="
    input="name=John"
    expected=""
    val2="$(extract_val_from_elem "${input}")"
    rc=$?
    sts_assert_equal "${expected}" "${val2}"
    sts_assert_equal "0" "${rc}"
}

test_upd_val() {
    local array="key1 value1
key2 value2
key3 value3"
    upd_val "array" "key2" "updated_value2"
    local upd_rc=$?
    local expected_array="key1 value1
key2 updated_value2
key3 value3"
    sts_assert_equal "${expected_array}" "${array}"
    sts_assert_equal "0" "${upd_rc}"
}

# Test to verify the change_variable function
test_replace_line_in_arr() {
    local array="Red line
Green line
Blue line"
    # Define the expected result after the replacement
    local expected_array="Red line
Yellow line
Blue line"
    # Replace the search string with the replacement string in the variable's value
    replace_line_in_arr "array" "Green line" "Yellow line"
    local upd_rc=$?
    sts_assert_equal "${expected_array}" "${array}"
    sts_assert_equal "0" "${upd_rc}"
}
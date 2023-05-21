#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_TEST_VAR_LIB_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_TEST_VAR_LIB_DIR}/../../shtest_lib/sts_helpers.sh"
# shellcheck disable=SC1091
. "${_TEST_VAR_LIB_DIR}/../var_lib.sh"

test_get_val_by_name() {
    local test_var=''
    local get_val_result

    test_var="test_value"
    get_val_result="$(get_val_by_name "test_var")"
    sts_assert_equal "test_value" "${get_val_result}"
}

test_set_by_name() {
    local test_var=''
    local get_val_result

    set_by_name "test_var" "new_value"
    get_val_result="$(get_val_by_name "test_var")"
    sts_assert_equal "new_value" "${get_val_result}"
}

test_add_to_end() {
    local test_var=''
    local get_val_result

    test_var='start_value'
    add_to_end "test_var" "_additional"
    get_val_result="$(get_val_by_name "test_var")"
    sts_assert_equal "start_value_additional" "${get_val_result}"
}

# Edge case tests
test_get_val_empty_name() {
    local get_val_result

    get_val_result="$(get_val_by_name "")"
    sts_assert_equal '' "${get_val_result}"
}

test_set_by_empty_name() {
    local get_val_result

    set_by_name '' "new_value"
    get_val_result="$(get_val_by_name "")"
    sts_assert_equal '' "${get_val_result}"
}

test_add_to_end_empty_name() {
    local get_val_result

    add_to_end "" "_additional"
    get_val_result="$(get_val_by_name "")"
    sts_assert_equal "" "${get_val_result}"
}
#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_TEST_TEXT_LIB_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_TEST_TEXT_LIB_DIR}/sts_helpers.sh"
# shellcheck disable=SC1091
. "${_TEST_TEXT_LIB_DIR}/../src/text_lib.sh"

var="line1
line2
line3
line4"

test_get_count_lines() {
  lines_count="$(get_count_lines var)"
  sts_assert_equal "4" "$lines_count"
}

test_get_line_val() {
    get_line_val_result="$(get_line_val var 2)"
    sts_assert_equal "line2" "$get_line_val_result"
}

test_del_line_by_num() {
    del_line_by_num var 2
    lines_count_result_after_del="$(get_count_lines var)"
    sts_assert_equal "3" "$lines_count_result_after_del"

    res_line1="$(get_line_val var 1)"
    sts_assert_equal "line1" "$res_line1"

    res_line2="$(get_line_val var 2)"
    sts_assert_equal "line3" "$res_line2"

    res_line3="$(get_line_val var 3)"
    sts_assert_equal "line4" "$res_line3"
}
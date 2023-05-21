#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

sts_assert_equal() {
    local expected="$1"
    local actual="$2"

    if [ "${expected}" = "${actual}" ]; then
      echo "  - PASSED"
      passed=$((passed + 1))
      return 0
    else
      echo "  - FAILED: Expected '${expected}', got '${actual}'"
      failed=$((failed + 1))
      return 1
    fi
}

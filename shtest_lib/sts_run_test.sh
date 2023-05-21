#!/bin/ash
# shellcheck shell=dash
# shellcheck enable=require-variable-braces

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 path_to_test_script"
  exit 1
fi
test_script_path=$1

# Source the test script
. ./"${test_script_path}"

main() {
  local passed=0
  local failed=0

  # Search all lines with functions with name started from "test_*"
  #   then start this function
  for func in $(grep -oP "^test_\w+" "${test_script_path}"); do
      tested_func_name=${func#test_}
      echo "= = Testing function '${tested_func_name}' = ="
      $func
      echo
  done

  echo "Tests passed: ${passed}"
  echo "Tests failed: ${failed}"

  return 0
}

main
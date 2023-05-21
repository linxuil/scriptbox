# Get the absolute path to the current directory with the given script
# shellcheck disable=SC3000-SC4000
if [ "${BASH}" ]; then _SPATH="$(realpath "${BASH_SOURCE[0]}")"
else _SPATH="$(readlink /proc/"$$"/fd/*|grep -v '/dev/\|pipe:\['|tail -1)"; fi
_GEA_EX_DIR="$(dirname "$(readlink -f "${_SPATH}")")"
# shellcheck disable=SC1091
. "${_GEA_EX_DIR}/gea_lib.sh"

my_array=''

# Пример использования:
new_array my_array
add_elem my_array "first item"
add_elem my_array "second item"

echo "Array:
${my_array}"
echo

elem2="$(get_elem "my_array" "1")"
echo "Second item: '${elem2}'"
del_elem my_array 0
echo "First item after removal: $(get_elem my_array 0)"
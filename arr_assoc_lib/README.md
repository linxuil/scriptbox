# Associative Array Library for ash or bash

This [AS]sociative [A]rray library provides basic functions for working with associative arrays in ash or bash. Library worked in busybox ASH.

## Limitations

- Array keys and values should not contain spaces or newlines.
- Array names should not contain spaces, newlines, or any special characters.
- This library doesn't support bash-specific syntax.

## Functions

- `add_elem <array_name> <key> <value>`
  Adds an element to the end of the array. If the key already exists, it returns an error code and doesn't update the value.
- `del_elem <array_name> <key>`
  Deletes an element from the array and shifts the indices.
- `get_val <array_name> <key>`
  Retrieves the value associated with the specified key.
- `upd_val <array_name> <key> <value>`
  Updates the value associated with the specified key.
- `get_idx <array_name> <key>`
  Retrieves the index of the specified key in the array.
- `get_qty <array_name>`
  Counts the total number of elements in the array.


## How can I use these associative arrays?

1. To read custom config files
2. For a convenient data storage structure after parsing, so as not to create a lot of disparate variables

## Usage

1. Include the library in your shell script:

   ```
   . ./associative_array_lib.sh
   ```

2. Use the functions to manipulate your associative arrays:

   ```
   local my_array=""
   add_elem "my_array" "key1" "value1"
   add_elem "my_array" "key2" "value2"
   get_val "my_array" "key1"  # Output: value1
   upd_val "my_array" "key1" "updated_value1"
   get_val "my_array" "key1"  # Output: updated_value1
   del_elem "my_array" "key1"
   ```

## Testing

To run the provided tests, execute the `associative_array_tests.sh` script:

```
./associative_array_tests.sh 1000 1000
```


## Result example

Busybox - shell `ash`:
```
# ./associative_array_tests.sh 1000 1000
Measured:
  ...awk time: 10
  ...sed time: 7
  ...head_tail time: 6
  ...time_diff_while_loop time: 3
Variant      Batch.Time(s)        ratio(%)
array:             N/A            N/A%
while loop:          3            100%
head & tail:         6            200%
sed:                 7            233%
perl:              N/A            N/A%
awk:                10            333%

#

```

Notebook - shell `bash`:
```
$ ./shell_script.sh 1000 1000
Measured:
  ...awk time: 4961471
  ...sed time: 4072802
  ...head_tail time: 3894314
  ...time_diff_while_loop time: 3192727
  ...array time: 2807129
  ...perl time: 5235913
Variant      Iter.Time(ns)        ratio(%)
array:         2807129            100%
while loop:    3192727            113%
head & tail:   3894314            138%
sed:           4072802            145%
perl:          5235913            186%
awk:           4961471            176%
$
```


Review of results
while loop surprised me the most - on small data volumes it can even be faster than array
awk and perl are slower than I expected - they have the worst results
"head & tail" and "sed" are faster than awk and perl - I didn't expect that.

Outcome
In the end, I chose "while loop" to implement arrays.
But I give the second place to "head & tail" since the readability
of this option is much higher than that of sed and the speed
is sometimes even higher than sed

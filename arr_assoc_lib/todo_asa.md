# @todo list

## 1. Implement `shift_elements`
Separate main part and helpers in arr_assoc_lib.sh

## 2. Implement `shift_elements`
Write a function to shift a range of elements to the right or left
+ When shifted to the right - the remaining lines become empty
+ When shifted to the left:
  - Old elements are replaced by new ones
  - If the offset is greater than there are free spaces - the offset elements are lost

## 3. Rewrite `del_elem`
Use `shift_elements`

## 4. Implement `inc_elem_after`
Write a function for the inserted element after some elements.
Use the `shift_elements` function for this

## list_contains
# PURPOSE: Check if an element is present in a given list
#
# INPUT: The function takes the following arguments:
#      - 1: Element to check for
#      - 2: Address of the buffer
#      - 3: Size of the buffer
#
# OUTPUT: %eax is set to 1 if the element is found in the list, else, it is set to 0
.extern list_contains

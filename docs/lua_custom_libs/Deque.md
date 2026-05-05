# Deque Abstract Type
## Description

A deque (a double-ended queue) is a data structure that allows for efficient insertion and removal of elements from both ends (from the beginning and from the end). Unlike a regular list or vector, push/pop operations on the ends of a deque are almost always O(1).
Deque is great for where you need a 'first in, first out' processing order plus the flexibility to add items to the front or back (PathFinding, Enemies UpdateQueue).

## Structure and Methods

### Creation, pushes, pops

Create and push elements:
```lua
local Deque = require("path_to_module")

local deq = Deque.new()

deq:push_front(1)
deq:push_front(2)

deq:push_back(3)
deq:push_back(4)

deq:print_deq()
```
Terminal:
```
2
1
3
4
```
Pop (delete elements):
```lua
deq:pop_front()
deq:print_deq()

print("\n")

deq:pop_back()
deq:print_deq()
```
Terminal:
```
1
3
4

1
3
```

### Methods Docs

- **`Deque.new()`**
  Creates and returns a new empty Deque instance.

- **`Deque:push_front(value)`**
  Inserts a new element at the front of the deque. Returns the created node table.

- **`Deque:push_back(value)`**
  Inserts a new element at the back of the deque. Returns the created node table.

- **`Deque:pop_front()`**
  Removes and returns the value of the element at the front of the deque. Returns `nil` if the deque is empty.

- **`Deque:pop_back()`**
  Removes and returns the value of the element at the back of the deque. Returns `nil` if the deque is empty.

- **`Deque:pop_node(node)`**
  Removes a specific node from the deque and returns its value. Throws an error if a nil value is passed.

- **`Deque:get_front()`**
  Returns the value of the element at the front without removing it. Returns `nil` if empty.

- **`Deque:get_back()`**
  Returns the value of the element at the back without removing it. Returns `nil` if empty.

- **`Deque:clear()`**
  Clears the entire deque, removing all elements.

- **`Deque:is_empty()`**
  Returns `true` if the deque contains no elements, `false` otherwise.

- **`Deque:toTable()`**
  Returns a standard array-like table containing all values in the deque, ordered from front to back.

- **`Deque:print_deq()`**
  Prints all elements in the deque to the standard output, from front to back.


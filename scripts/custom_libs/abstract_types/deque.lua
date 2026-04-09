local Deque = {}
Deque.__index = Deque

--- Creates a new empty deque
--- @return table table a new Deque instance
function Deque.new()
    local self = setmetatable({}, Deque)
    self.head = nil
    self.tail = nil
    return self
end

local function newNode(value)
    return {
        value = value,
        prev = nil,
        next = nil
    }
end

--- Inserts a new value at the front of the given deque
--- @param value any any the value to insert
--- @return table table node created with the value
function Deque:push_front(value)
    local node = newNode(value)
    
    if self.head then
        self.head.prev = node
        node.next = self.head
        self.head = node
    else
        self.head = node
        self.tail = node
    end
    
    return node
end

---Inserts a new value at the back of the given deque
---@param value any the value to insert
---@return table table node created with the value
function Deque:push_back(value)
    local node = newNode(value)
    
    if self.tail then
        self.tail.next = node
        node.prev = self.tail
        self.tail = node
    else
        self.head = node
        self.tail = node
    end
    
    return node
end

---Removes the value at the back of the deque and returns it
---@return any the removed value or nil if the deque is empty
function Deque:pop_back()
    if not self.tail then
        return nil
    end
    
    local value = self.tail.value
    self.tail = self.tail.prev
    
    if self.tail then
        self.tail.next = nil
    else
        self.head = nil
    end
    
    return value
end

---Removes the value at the front of the deque and returns it
--- @return any the removed value or nil if the deque is empty
function Deque:pop_front()
    if not self.head then
        return nil
    end
    
    local value = self.head.value
    self.head = self.head.next
    
    if self.head then
        self.head.prev = nil
    else
        self.tail = nil
    end
    
    return value
end

---Removes a specific node from the deque and returns its value
--- @param node table the node to remove
--- @return any the value of the removed node
function Deque:pop_node(node)
    if not node then return error("Node with the address " .. tostring(node) .. " does not exist") end

    if node.prev then
        node.prev.next = node.next
    else
        self.head = node.next
    end

    if node.next then
        node.next.prev = node.prev
    else
        self.tail = node.prev
    end

    node.prev = nil
    node.next = nil

    return node.value
end

---Returns the value at the front of the deque without removing it
---@return any the value at the front or nil if empty
function Deque:get_front()
    return self.head and self.head.value or nil
end

---Returns the value at the back of the deque without removing it
--- @return any the value at the back or nil if empty
function Deque:get_back()
    return self.tail and self.tail.value or nil
end

---Clears the deque, removing all elements
--- @return nil
function Deque:clear()
    self.head = nil
    self.tail = nil
end

---Checks if the deque is empty
--- @return boolean true if empty, false otherwise
function Deque:is_empty()
    return self.head == nil
end


---Converts the deque to a standard table array
--- @return table array containing all elements
function Deque:toTable()
    local t = {}
    local current = self.head
    while current do
        table.insert(t, current.value)
        current = current.next
    end
    return t
end

---Prints all elements in the deque from front to back
--- @return nil
function Deque:print_deq()
    local t = self:toTable()
    for i=1, #t do
        print(t[i])
    end
end

return Deque
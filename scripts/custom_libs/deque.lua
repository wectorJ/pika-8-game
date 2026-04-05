local Deque = {}
Deque.__index = Deque

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
    
    return self
end

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
    
    return self
end

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


function Deque:get_front()
    return self.head and self.head.value or nil
end

function Deque:get_back()
    return self.tail and self.tail.value or nil
end

function Deque:clear()
    self.head = nil
    self.tail = nil
end


function Deque:toTable()
    local t = {}
    local current = self.head
    while current do
        table.insert(t, current.value)
        current = current.next
    end
    return t
end

function print_t(t)
    for i=1, #t do
        print(t[i])
    end
end


--TODO move tests to other file 
local deq = Deque.new()

deq:push_back(1)
deq:push_back(2)
deq:push_back(3)
deq:push_back(4)

print_t(deq:toTable())

print("\n")

deq:push_front(5)
deq:push_front(6)
deq:push_front(7)
deq:push_front(8)

print_t(deq:toTable())
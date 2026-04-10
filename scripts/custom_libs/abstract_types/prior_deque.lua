--TODO cache min/max prior for O(1)

local Deque = require("scripts.custom_libs.abstract_types.deque")

---Priority Deque
local PriorDeque = {}
PriorDeque.__index = PriorDeque

function PriorDeque.new(max_priority)
    local self = setmetatable({}, PriorDeque)

    self.max_priority = max_priority or 10

    self.prior_list = {}
    for i = 1, self.max_priority do
        self.prior_list[i] = Deque.new()
    end

    self.deque = Deque.new()
    self.min_ptr = self.max_priority + 1
    self.max_ptr = 0

    return self
end

local function createPriorDeque_Node(data, priority)
    return {
        data = data,
        priority = priority,
        bucket_node = nil
    }
end

function PriorDeque:enqueue(data, priority)
    if data == nil then
        error("Required parameter data is missing")
    end
    if not priority then
        error("Required parameter priority is missing. Max priority is " .. self.max_priority .. ", min priority is 1")
    end
    if priority < 1 or priority > self.max_priority then
        error("Priority is out of range")
    end

    local item = createPriorDeque_Node(data, priority)
    local deque_node = self.deque:push_back(item)
    local bucket = self.prior_list[priority]:push_back(deque_node) -- bucket_node.value is a reference to deque_node
    item.bucket_node = bucket

    --[ ] after adequate optimization delete
    if priority < self.min_ptr then 
        self.min_ptr = priority 
    end
    if priority > self.max_ptr then
        self.max_ptr = priority 
    end
end

local function remove_by_deque_node(self, deque_node)
    local priority = deque_node.value.priority
    local data = deque_node.value.data
    local bucket_node = deque_node.value.bucket_node

    self.deque:pop_node(deque_node)
    self.prior_list[priority]:pop_node(bucket_node)

    return data, priority
end

local function remove_by_priority(self, p)
    --TODO only head, it might be worth doing it both ways.
    local bucket_node = self.prior_list[p].head
    local deque_node = bucket_node.value
    local data = deque_node.value.data

    self.prior_list[p]:pop_front()
    self.deque:pop_node(deque_node)

    return data, p
end

---Peek at the value of the Priority Deque
---@param mode string modes: "lowest", "highest", "oldest" or "newest"
function PriorDeque:peek(mode)
    if mode == "lowest" then
        --[ ] after adequate optimization redo
        for i = self.min_ptr, self.max_priority do
            if self.prior_list[i].head then
                self.min_ptr = i
                local v = self.prior_list[i].head.value.value
                return v.data, i
            end
        end
        return nil

    elseif mode == "highest" then
        --[ ] after adequate optimization redo
        for i = self.max_ptr, 1, -1 do
            if self.prior_list[i].head then
                self.max_ptr = i
                local v = self.prior_list[i].head.value.value
                return v.data, i
            end
        end
        return nil

    elseif mode == "oldest" then
        if not self.deque.head then return nil end
        local v = self.deque.head.value
        return v.data, v.priority

    elseif mode == "newest" then
        if not self.deque.tail then return nil end
        local v = self.deque.tail.value
        return v.data, v.priority

    else
        error("peek: unknown mode  '".. tostring(mode) .. "'")
    end
end

---@param mode string modes: "lowest", "highest", "oldest" or "newest"
function PriorDeque:dequeue(mode)
    if mode == "lowest" then
        local _, p = self:peek("lowest")
        if not p then return nil end
        local data, priority = remove_by_priority(self, p)

        --[ ] after adequate optimization delete
        if not self.prior_list[p].head then
            self.min_ptr = p + 1
        end
        return data, priority

    elseif mode == "highest" then
        local _, p = self:peek("highest")
        if not p then return nil end
        local data, priority = remove_by_priority(self, p)

        --[ ] after adequate optimization delete
        if not self.prior_list[p].head then
            self.max_ptr = p - 1
        end
        return data, priority

    elseif mode == "oldest" then
        if not self.deque.head then return nil end
        return remove_by_deque_node(self, self.deque.head)

    elseif mode == "newest" then
        if not self.deque.tail then return nil end
        return remove_by_deque_node(self, self.deque.tail)
        
    else
        error("dequeue: unknown mode '" .. tostring(mode) .. "'")
    end
end

function PriorDeque:is_empty()
    return self.deque:is_empty()
end

return PriorDeque
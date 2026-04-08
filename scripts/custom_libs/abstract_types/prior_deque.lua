--TODO cache min/max prior for O(1 or less const)

local Deque = require("scripts.custom_libs.abstract_types.deque")

---Priority Deque
local PriorDeque = {}
PriorDeque.__index = PriorDeque

function PriorDeque.new(max_priority)
    local self = setmetatable({}, PriorDeque)

    self.max_priority = max_priority or 10

    self.prior_list = {}
    for i = 0, self.max_priority do
        self.prior_list[i] = Deque.new()
    end

    self.deque = Deque.new()
    self.min_ptr = 0
    self.max_ptr = self.max_priority

    return self
end

function PriorDeque:enqueue(data, priority)
    if priority < 1 or priority > self.max_priority then
        error(string.format("enqueue: priority out of range"))
    end

    local deque_node = self.deque:push_back({ data = data, priority = priority })
    local bucket_node = self.prior_list[priority]:push_back(deque_node)
    deque_node.value.bucket_node = bucket_node

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
    local bucket_node = self.prior_list[p].head
    local deque_node  = bucket_node.value
    local data        = deque_node.value.data

    self.prior_list[p]:pop_front()
    self.deque:pop_node(deque_node)

    return data, p
end

local peek_impl = {
    lowest = function(self)
        for i = self.min_ptr, self.max_priority do
            if self.prior_list[i].head then
                self.min_ptr = i
                local v = self.prior_list[i].head.value.value
                return v.data, i
            end
        end
    end,

    highest = function(self)
        for i = self.max_ptr, 0, -1 do
            if self.prior_list[i].head then
                self.max_ptr = i
                local v = self.prior_list[i].head.value.value
                return v.data, i
            end
        end
    end,

    oldest = function(self)
        if not self.deque.head then return nil end
        local v = self.deque.head.value
        return v.data, v.priority
    end,

    newest = function(self)
        if not self.deque.tail then return nil end
        local v = self.deque.tail.value
        return v.data, v.priority
    end,
}

function PriorDeque:peek(mode)
    local fn = peek_impl[mode]
    if not fn then
        error("peek: unknown mode '" .. tostring(mode) .. "'")
    end
    return fn(self)
end

local dequeue_impl = {
    lowest = function(self)
        local _, p = peek_impl.lowest(self)
        if not p then return nil end
        local data, priority = remove_by_priority(self, p)
        if not self.prior_list[p].head then
            self.min_ptr = p + 1
        end
        return data, priority
    end,

    highest = function(self)
        local _, p = peek_impl.highest(self)
        if not p then return nil end
        local data, priority = remove_by_priority(self, p)
        if not self.prior_list[p].head then
            self.max_ptr = p - 1
        end
        return data, priority
    end,

    oldest = function(self)
        if not self.deque.head then return nil end
        return remove_by_deque_node(self, self.deque.head)
    end,

    newest = function(self)
        if not self.deque.tail then return nil end
        return remove_by_deque_node(self, self.deque.tail)
    end,
}

function PriorDeque:dequeue(mode)
    local fn = dequeue_impl[mode]
    if not fn then
        error("dequeue: unknown mode '" .. tostring(mode) .. "'")
    end
    return fn(self)
end

return PriorDeque
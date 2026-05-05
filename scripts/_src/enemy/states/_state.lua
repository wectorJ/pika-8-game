local State = {}
State.__index = State

--- Class constructor
--- @param name string state name (for debug)
--- @return table new state object
function State:new(name)
    local self = setmetatable({}, State)
    self.name = name or "unnamed"
    return self
end

--- calling once when enemy enters this state
function State:enter(enemy) end

--- calling every frame
function State:update(enemy, dt) end

--- calling once when enemy enters this state
function State:exit(enemy) end

local FSM = {}
FSM.__index = FSM

--- Class constructor
--- @param owner table state owner
--- @param initial_state table initial state object
--- @return table new FSM object
function FSM:new(owner, initial_state)
    local self = setmetatable({}, FSM)
    self.owner = owner
    self.state = nil

    if initial_state then
        self:set_state(initial_state)
    end

    return self
end

--- switch state
function FSM:set_state(new_state)
    if self.state then
        self.state:exit(self.owner)
    end

    self.state = new_state

    if self.state then
        self.state:enter(self.owner)
    end
end

function FSM:update(dt)
    if self.state then
        self.state:update(self.owner, dt)
    end
end

--- for debug
function FSM:get_state_name()
    if self.state then
        return self.state.name
    end
    return "none"
end

State.FSM = FSM

return State

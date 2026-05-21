local Vec2 = require("scripts.custom_libs.abstract_types.vec2")
local Chunker = require("scripts._src.ai.chunker")
local EventEmitter = require("scripts.custom_libs.event_emitter")
local EventProxy = require("scripts.custom_libs.event_proxy")
local VFDecorators = require("scripts._src.ai.vector_field_D")
local State = require("scripts._src.ai._state")

local VectorFieldStream = {}

--TODO separate states into separate files, try to use a ready-made FSM
--#region StateMachine
local FieldStates = {
	idle = State:new("idle"),
	moving = State:new("moving")
}

function FieldStates.idle:make_vec()
	return Vec2:new(1, 1)
end

function FieldStates.moving:make_vec()
	return Vec2:new(2, 2)
end
--#endregion

--- Main stream
local function stream(height, width, chunk_size, vec_provider)
	local chunks = Chunker.create_chunks(height, width, chunk_size)
	local get_vec = vec_provider or function()
		return FieldStates.idle:make_vec()
	end
	return coroutine.create(function ()
		for i = 1, #chunks do
			local chunk = chunks[i]
			chunk.data.vec = get_vec()
			coroutine.yield(chunk)
		end
	end)
end

local function create_stream(height, width, chunk_size, opts)
	local options = opts or {}
	local emitter = EventProxy.event_throttling(
		EventEmitter,
		options.event_min_interval_sec
	)

	local state = FieldStates.idle
	local function set_state(next_state)
		if state ~= next_state then
			state = next_state
		end
	end

	local unsubscribe_moving = emitter:on("ship_moving", function()
		set_state(FieldStates.moving)
	end)
	local unsubscribe_stopped = emitter:on("ship_stopped", function()
		set_state(FieldStates.idle)
	end)

	local co = stream(height, width, chunk_size, function()
		local vec = state:make_vec()
		return vec
	end)

	local function unsubscribe()
		unsubscribe_moving()
		unsubscribe_stopped()
	end

	return co, unsubscribe
end

local dtest = VFDecorators.log(VFDecorators.filter(create_stream, function(chunk)
	return chunk.data.vec.x == 1
end))

local co, u = dtest(100, 50, 10)

while coroutine.status(co) ~= "dead" do
    local ok, chunk = coroutine.resume(co)
    if not ok then error(chunk) end
end

u()

function VectorFieldStream.example(height, width, chunk_size)
	local iters = 0
	local total = 0
	local count = 0

	local stream = stream(height, width, chunk_size)
	while coroutine.status(stream) ~= "dead" do
		iters = iters + 1
		local ok, chunk = coroutine.resume(stream)
		if not ok then
			error(chunk)
		end
		if chunk ~= nil then
			total = total + chunk.data.vec:length()
			count = count + 1
		end
	end

	if count == 0 then
		return 0
	end

	return total / count, iters - 1 -- -1 because coroutine does one more resume before dying
end

function VectorFieldStream.create_field(height, width, chunk_size)
	local stream = stream(height, width, chunk_size)
	local field = {}
	while coroutine.status(stream) ~= "dead" do
		local ok, chunk = coroutine.resume(stream)
		if not ok then
			error(chunk)
		end
		if chunk ~= nil then
			table.insert(field, chunk)
		end
	end
	return field
end

return VectorFieldStream

-- local h, w, cs = 100, 50, 10

-- local result, iters = VectorFieldStream.example(h, w, cs)
-- print("Average vector length: " .. result)
-- print("Iterations: " .. iters)

-- local field = VectorFieldStream.create_field(h, w, cs)
-- for _, chunk in ipairs(field) do -- _ is index
-- 	print(chunk.data.vec, " ")
-- end
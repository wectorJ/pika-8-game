local Vec2 = require("scripts.custom_libs.abstract_types.vec2")
local Chunker = require("scripts._src.ai.chunker")
local EventEmitter = require("scripts.custom_libs.event_emitter")
local EventProxy = require("scripts.custom_libs.event_proxy")
local Logger = require("scripts.custom_libs.logger")
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

local function create_stream_base(height, width, chunk_size, opts)
	local options = opts or {}
	local emitter = EventProxy.event_throttling(
		EventEmitter,
		options.event_min_interval_sec
	)

	local function wrap_handler(label, handler)
		if type(options.wrap_handler) == "function" then
			return options.wrap_handler(label, handler)
		end
		return handler
	end

	local function notify_state(next_state)
		if type(options.on_state_change) == "function" then
			options.on_state_change(next_state)
		end
	end

	local function notify_vec(vec, state)
		if type(options.on_vec) == "function" then
			options.on_vec(vec, state)
		end
	end

	local state = FieldStates.idle
	local function set_state(next_state)
		if state ~= next_state then
			state = next_state
			notify_state(state)
		end
	end

	local unsubscribe_moving = emitter:on("ship_moving", wrap_handler("ship_moving", function()
		set_state(FieldStates.moving)
	end))
	local unsubscribe_stopped = emitter:on("ship_stopped", wrap_handler("ship_stopped", function()
		set_state(FieldStates.idle)
	end))

	local co = stream(height, width, chunk_size, function()
		local vec = state:make_vec()
		notify_vec(vec, state)
		return vec
	end)

	local function unsubscribe()
		unsubscribe_moving()
		unsubscribe_stopped()
	end

	return co, unsubscribe
end

--BY_AI
local function decorate_create_stream(create_stream_fn)
	return function(height, width, chunk_size, opts)
		local options = opts or {}
		local logger = Logger:new({
			level = options.log_level or "INFO",
			tag = options.log_tag or "VectorFieldStream"
		})

		logger:info("create_stream")

		local decorated_opts = {}
		for key, value in pairs(options) do
			decorated_opts[key] = value
		end

		decorated_opts.wrap_handler = function(label, handler)
			return logger:wrap_handler(label, handler)
		end
		decorated_opts.on_state_change = function(next_state)
			logger:info("state=" .. (next_state.name or "unknown"))
			if type(options.on_state_change) == "function" then
				options.on_state_change(next_state)
			end
		end
		decorated_opts.on_vec = function(vec, state)
			local state_name = "unknown"
			if state and state.name then
				state_name = state.name
			end
			logger:debug("vec=" .. tostring(vec) .. " state=" .. state_name)
			if type(options.on_vec) == "function" then
				options.on_vec(vec, state)
			end
		end

		local ok, co, unsubscribe = pcall(create_stream_fn, height, width, chunk_size, decorated_opts)
		if not ok then
			logger:error("create_stream failed: " .. tostring(co))
			return nil, function() end
		end

		local function safe_unsubscribe()
			local ok_unsub, err = pcall(unsubscribe)
			if not ok_unsub then
				logger:error("unsubscribe error: " .. tostring(err))
			else
				logger:info("unsubscribed")
			end
		end

		return co, safe_unsubscribe
	end
end

local create_stream_with_logging = decorate_create_stream(create_stream_base)

--- Create a TEST vector field stream that changes based on ship movement events
---@param height number - field height
---@param width number - field width
---@param chunk_size number - size of chunks to divide the field into
---@param opts table - options for logging and event throttling
---@return thread co, function unsubscribe - the stream coroutine and an unsubscribe function to clean up event listeners
function VectorFieldStream.create_stream(height, width, chunk_size, opts)
	return create_stream_with_logging(height, width, chunk_size, opts)
end

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
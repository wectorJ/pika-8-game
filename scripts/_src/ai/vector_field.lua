local Vec2 = require("scripts.custom_libs.abstract_types.vec2")
local Chunker = require("scripts._src.ai.chunker")

local VectorFieldStream = {}

local function stream(height, width, chunk_size)
	local chunks = Chunker.create_chunks(height, width, chunk_size)
	return coroutine.create(function ()
		for i = 1, #chunks do
			local chunk = chunks[i]
			chunk.data.vec = Vec2:new(1, 1)
			coroutine.yield(chunk)
		end
	end)
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

local h, w, cs = 100, 50, 10

local result, iters = VectorFieldStream.example(h, w, cs)
print("Average vector length: " .. result)
print("Iterations: " .. iters)

local field = VectorFieldStream.create_field(h, w, cs)
for _, chunk in ipairs(field) do
	print(chunk.data.vec, " ")
end
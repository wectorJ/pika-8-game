local Vec2 = require("scripts.custom_libs.abstract_types.vec2")

local VectorFieldStream = {}

local function stream(height, width, chunk_size)
	return coroutine.create(function ()
		for chunk_y = 1, height, chunk_size do
			for chunk_x = 1, width, chunk_size do

				--TODO return 1 vector per 1 chunk -> create chunker func
				local chunk = {}
				for y = chunk_y, math.min(chunk_y + chunk_size - 1, height) do -- clamp
					chunk[y] = {}
					for x = chunk_x, math.min(chunk_x + chunk_size - 1, width) do
						local vec = Vec2:new(
							1,1
						)
						
						chunk[y][x] = vec
					end
				end

				coroutine.yield(chunk)
			end
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
			for _, row in pairs(chunk) do
				for _, vec in pairs(row) do
					total = total + vec:length()
					count = count + 1
				end
			end
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
			for y, row in pairs(chunk) do
				field[y] = {}
				for x, vec in pairs(row) do
					field[y][x] = vec
				end
			end
		end
	end
	return field
end

local h, w, cs = 5, 5, 10

local result, iters = VectorFieldStream.example(h, w, cs)
print("Average vector length: " .. result)
print("Iterations: " .. iters)

local field = VectorFieldStream.create_field(h, w, cs)
for y, row in pairs(field) do
	for x, vec in pairs(row) do
		print(vec, " ")
	end
	print("\n")
end
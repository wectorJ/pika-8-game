local Vec2 = require("scripts.custom_libs.abstract_types.vec2")

local VectorFieldStream = {}

function VectorFieldStream.stream(height, width, chunk_size)
	return coroutine.create(function ()
		for chunk_y = 1, height, chunk_size do
			for chunk_x = 1, width, chunk_size do

				local chunk = {}
				for y = chunk_y, math.min(chunk_y + chunk_size - 1, height) do -- clamp
					chunk[y] = {}
					for x = chunk_x, math.min(chunk_x + chunk_size - 1, width) do
						local vec = Vec2(
							math.random(-1, 1),
							math.random(-1, 1)
						)
						
						chunk[y][x] = vec
					end
				end

				coroutine.yield(chunk)
			end
		end
	end)
end


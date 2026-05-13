--BY_AI

local Chunker = {}

function Chunker.create_chunks(height, width, chunk_size)
	if height <= 0 or width <= 0 or chunk_size <= 0 then
		return {}
	end

	local step_y = math.min(chunk_size, height)
	local step_x = math.min(chunk_size, width)
	local chunks = {}
	for chunk_y = 1, height, step_y do
		for chunk_x = 1, width, step_x do
			local chunk = {
				x1 = chunk_x,
				y1 = chunk_y,
				x2 = math.min(chunk_x + step_x - 1, width),
				y2 = math.min(chunk_y + step_y - 1, height),
				data = {}
			}
			table.insert(chunks, chunk)
		end
	end
	return chunks
end

return Chunker

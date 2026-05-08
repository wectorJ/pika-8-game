--BY_AI needs to be reviewed; temp placeholder for vector field

local flow_field_stream = {}

-- Creates a generator object for incremental flow-field work.
-- Config keys are placeholders and can be adjusted later.
function flow_field_stream.new_generator(config)
  local gen = {
    goal = config.goal,
    grid = config.grid,
    chunk_size = config.chunk_size or 16,
    budget_cells = config.budget_cells or 256,
    queue = {},
    cost = {},
    done = false,
  }

  -- TODO: initialize queue with goal position
  -- TODO: set cost for goal

  return gen
end

-- Advances the generator by one chunk of work.
-- Returns: chunk (table) or nil if no more work.
function flow_field_stream.next_chunk(gen)
  if gen.done then
    return nil
  end

  -- TODO: process up to gen.budget_cells steps from the queue
  -- TODO: build a chunk result with cells and metadata
  -- TODO: set gen.done when queue is empty

  local chunk = {
    cells = {},
    ready_chunks = {},
    done = false,
  }

  return chunk
end

return flow_field_stream

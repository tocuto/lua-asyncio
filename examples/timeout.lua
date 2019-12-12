local asyncio = require "lua-asyncio"
local async = asyncio.async

local loop = asyncio.loops.EventLoop.new()
-- you might change the intervals depending on what your os.time() returns

local eternity = async(function()
	print("Start eternity")
	loop:sleep(3600)
	print("End eternity")
end)

local long_task = async(function()
	print("Start waiting")

	local task = eternity()
	loop:await_for(task, 1)
	if task.cancelled then
		print("Task cancelled.")
	elseif task.error then
		error(task.error)
	else
		print("Task successfully finished.")
	end

	print("End")
end)

loop:add_task(long_task())

while true do
	loop:run()
end

--[[ OUTPUT OF THE PROGRAM:
Start waiting
Start eternity
Task cancelled.
End
]]
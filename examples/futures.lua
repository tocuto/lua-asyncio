local asyncio = require "lua-asyncio"
local async = asyncio.async

local loop = asyncio.loops.EventLoop.new()
local future = loop:new_object(asyncio.futures.Future)
-- you might change the intervals depending on what your os.time() returns

local long_task_1 = async(function()
	loop:sleep(2)
	print("Long task 1 finished")
	return "something", "else", "with", "many", "arguments"
end)

local long_task_2 = async(function()
	loop:sleep(7)
	print("Long task 3 finished")
end)

local long_task_3 = async(function()
	print("Start waiting")

	local semaphore = loop:await_many(future, long_task_1(), long_task_2())
	local result = loop:await(semaphore)

	print("Future result", table.unpack(result[1]))
	print("Task 2 result", table.unpack(result[2]))
	print("Task 3 result", table.unpack(result[3]))

	print("End")
end)

loop:add_task(long_task_3())
loop:add_task(asyncio.Task.new(function()
	loop:sleep(5)
	future:set_result({true, 56})
	-- It is required to feed set_result with a table.
	print("Set future result.")
end))

while true do
	loop:run()
end

--[[ OUTPUT OF THE PROGRAM:
Start waiting
Long task 1 finished
Set future result.
Long task 3 finished
Future result	true	56
Task 2 result	something	else	with	many	arguments
Task 3 result
End
]]
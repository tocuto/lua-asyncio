local asyncio = require "lua-asyncio"
local async = asyncio.async

local loop = asyncio.loops.EventLoop.new()
local queue = loop:new_object(asyncio.queues.Queue)

local giver = async(function()
	print("Start giving")
	for x = 1, 12 do
		print("Giving", x)
		loop:await(queue:add({val = x}))
	end
	print("End giving")
end)

local receiver = async(function(id)
	print("Starting receiver", id)

	while true do
		local data = loop:await(queue:get())

		print("Receiver", id, data.val)
	end
end)

loop:add_task(giver())
loop:add_task(receiver(1))
loop:add_task(receiver(2))
loop:add_task(receiver(3))

while true do
	loop:run()
end

-- As you know, EventLoop is not ordered just to make it faster
-- So, in this example, 3rd receiver will receive first, then 2nd and then 1st.
-- If you added more tasks, this order will probably be different and change over time.
-- However, if you need to make it an ordered process, you must use OrderedEventLoop instead.
--[[ OUTPUT OF THE PROGRAM:
Start giving
Giving	1
Starting receiver	1
Starting receiver	2
Starting receiver	3
Giving	2
Receiver	3	1
Giving	3
Receiver	2	2
Giving	4
Receiver	1	3
Giving	5
Receiver	3	4
Giving	6
Receiver	2	5
Giving	7
Receiver	1	6
Giving	8
Receiver	3	7
Giving	9
Receiver	2	8
Giving	10
Receiver	1	9
Giving	11
Receiver	3	10
Giving	12
Receiver	2	11
End giving
Receiver	1	12
]]
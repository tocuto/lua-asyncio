local asyncio = require "lua-asyncio"
local async = asyncio.async

local loop = asyncio.loops.LimitedEventLoop.new({}, 0.001, 10)
-- you might change the intervals depending on what your os.time() returns

-- You can also use:
-- local loop = asyncio.loops.MixedEventLoop({}, OrderedEventLoop, LimitedEventLoop).new()
-- loop.runtime = 0.001
-- loop.reset = 10

local long_task = async(function()
	print("Start waiting")

	local start = os.time()
	while os.time() - start < 1 do end
	print("End waiting")

	loop:sleep_until(0)
	-- basically waits for the next loop iteration

	print("Continue")

	loop:sleep_until(0)

	print("End")
end)

loop:add_task(long_task())

while true do
	loop:run()
end

--[[ OUTPUT OF THE PROGRAM:
Start waiting
-- 1 second later
End waiting
-- 9 seconds later
Continue
End
]]
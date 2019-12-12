local loops = require "lua-asyncio/event_loop"
local futures = require "lua-asyncio/futures"
local tasks = require "lua-asyncio/tasks"
local timers = require "lua-asyncio/timer_list"
local sync = require "lua-asyncio/synchronization"
local queues = require "lua-asyncio/queues"

return {
	loops = loops,
	futures = futures,
	sync = sync,
	queues = queues,
	Task = tasks.Task,
	async = tasks.async,
	TimerList = timers.TimerList,
	get_event_loop = loops.get_event_loop
}
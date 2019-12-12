local loops = require "lua-asyncio/event_loop"
local futures = require "lua-asyncio/futures"
local tasks = require "lua-asyncio/tasks"
local timers = require "lua-asyncio/timer_list"
local sync = require "lua-asyncio/synchronization"

return {
	loops = loops,
	futures = futures,
	sync = sync,
	Task = tasks.Task,
	async = tasks.async,
	TimerList = timers.TimerList,
	get_event_loop = loops.get_event_loop
}
local loops = require "event_loop"
local futures = require "futures"
local tasks = require "tasks"
local timers = require "timer_list"

return {
	loops = loops,
	futures = futures,
	Task = tasks.Task,
	async = tasks.async,
	TimerList = timers.TimerList
}
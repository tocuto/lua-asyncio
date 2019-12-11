local TimerList = require "timer_list"
local Future, FutureSemaphore = require "futures"
local Task, async = require "tasks"

local EventLoop
do
	local time = os.time
	local yield = coroutine.yield

	EventLoop = {}
	local meta = {__index = EventLoop}

	function EventLoop.new(obj)
		obj = obj or {}
		obj.timers = TimerList.new()
		obj.tasks = {}
		obj.removed = {}
		obj.tasks_index = 0
		return setmetatable(obj, meta)
	end

	function EventLoop.timers_callback(callback)
		return callback.event_loop:add_task(callback.task)
	end

	function EventLoop:sleep(delay)
		self:call_soon(delay, self.current_task, true)
		return self:stop_task_execution()
	end

	function EventLoop:call_soon(delay, task, no_future)
		return self:schedule(time() + delay, task, no_future)
	end

	function EventLoop:sleep_until(when)
		self:schedule(when, self.current_task, true)
		return self:stop_task_execution()
	end

	function EventLoop:schedule(when, task, no_future)
		self.timers:add {
			callback = self.timers_callback,
			when = when or 0,
			task = task,
			event_loop = self
		}

		if not no_future then
			local future = self:new_future()
			task:add_future(future)
			return future
		end
	end

	function EventLoop:add_task(task)
		self.tasks_index = self.tasks_index + 1
		self.tasks[self.tasks_index] = task
	end

	function EventLoop:new_future()
		return Future.new(self)
	end

	function EventLoop:new_future_semaphore(quantity)
		return FutureSemaphore.new(self, quantity)
	end

	function EventLoop:stop_task_execution()
		self.current_task.paused = true
		return yield()
	end

	function EventLoop:await(aw)
		if aw._is_future then
			-- if it is a future object it can't be appended to the task list _yet_
			aw._next_tasks_index = aw._next_tasks_index + 1
			aw._next_tasks[aw._next_tasks_index] = self.current_task
		else
			aw._next_task = self.current_task
			self:add_task(aw)
		end
		return self:stop_task_execution()
	end

	function EventLoop:await_many(...)
		local length = select("#", ...)
		local semaphore = self:new_future_semaphore(length)

		local task
		for index = 1, length do
			task = select(index, ...)
			task:add_future(semaphore, index)
			self:add_task(task)
		end

		return self:await(semaphore)
	end

	function EventLoop:run()
		self.timers:run()
		self:run_tasks()
		self:remove_tasks()
	end

	function EventLoop:run_tasks()
		local tasks, now, removed, task = self.tasks, time(), self.removed

		for index = 1, self.tasks_index do
			task = tasks[index]

			if not task.cancelled then
				self.current_task = task
				task:run(self)

				if task.cancelled or task.paused or task.done then
					task.paused = false
					self.removed_index = self.removed_index + 1
					removed[self.removed_index] = index
				end
			else
				self.removed_index = self.removed_index + 1
				removed[self.removed_index] = index
			end
		end

		self.current_task = nil
	end

	function EventLoop:remove_tasks()
		local tasks, removed, remove = self.tasks, self.removed
		for index = 1, self.removed_index do
			remove = removed[index]

			if remove < self.tasks_index then
				tasks[remove] = tasks[self.tasks_index]
				-- tasks[self.tasks_index] = nil
			end

			self.tasks_index = self.tasks_index - 1
		end

		self.removed_index = 0
	end
end

local LimitedEventLoop
do
	local time = os.time

	LimitedEventLoop = setmetatable(
		{}, {__index = EventLoop}
	)
	local meta = {__index = LimitedEventLoop}

	function LimitedEventLoop.new(runtime, reset, obj)
		obj = EventLoop.new(obj)
		obj.runtime = runtime
		obj.reset = reset
		obj.used = 0
		obj.initialized = 0
		obj.step = 0
		return setmetatable(obj, meta)
	end

	function LimitedEventLoop:can_run(now)
		return self.used + now < self.runtime
	end

	function LimitedEventLoop:run()
		local start = time()

		if start - self.initialized >= self.reset then
			self.initialized = start
			self.used = 0
		end

		if self.step == 0 then
			if self:can_run(0) then
				self.timers:run()
				self.step = 1
			end
		end

		if self.step == 1 then
			if self:can_run(time() - start) then
				self:run_tasks()
				self.step = 2
			end
		end

		if self.step == 2 then
			if self:can_run(time() - start) then
				self:remove_tasks()
				self.step = 0
			end
		end
	end
end

return {
	EventLoop = EventLoop,
	LimitedEventLoop = LimitedEventLoop,
	Task = Task,
	TimerList = TimerList,
	Future = Future,
	FutureSemaphore = FutureSemaphore,

	async = async
}
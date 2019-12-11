local Future
do
	Future = {}
	local meta = {__index = Future}

	--[[@
		@name new
		@desc Creates a new instance of Future: an object that will return later. You can use EventLoop:await on it, but you can't use EventLoop:add_task.
		@desc If you await it, it will return the :set_result() unpacked table. If you set the result to {"a", "b", "c"}, it will return "a", "b", "c".
		@desc /!\ If you safely await it, it will return nil and you need to manually check its error.
		@param loop<EventLoop> The loop that the future belongs to
		@param obj?<table> The table to turn into a Future.
		@returns Future The Future object
		@struct {
			_is_future = true, -- used to denote that it is a Future object
			loop = EventLoop, -- the loop that the future belongs to
			_next_tasks = {}, -- the tasks that the Future is gonna run once it is done
			_next_tasks_index = 0, -- the tasks table pointer
			result = nil or table, -- the Future result; if it is nil, it didn't end yet.
			error = false or string, -- whether the future has thrown an error or not
			cancelled = false, -- whether the future is cancelled or not
			done = false -- whether the future is done or not
		}
	]]
	function Future.new(loop, obj)
		obj = obj or {}
		obj._is_future = true
		obj.loop = loop
		obj._next_tasks = {}
		obj._next_tasks_index = 0
		return setmetatable(obj, meta)
	end

	--[[@
		@name cancel
		@desc Cancels the Future
	]]
	function Future:cancel()
		self.cancelled = true
	end

	--[[@
		@name set_result
		@desc Sets the Future result and calls all the scheduled tasks
		@param result<table> A table (with no associative members) to set as the result. Can have multiple items.
	]]
	function Future:set_result(result)
		if self.done then
			error("The Future has already been done.", 2)
		elseif self.cancelled then
			error("The Future was cancelled.", 2)
		end

		self.done = true
		self.result = result

		local task
		for index = 1, self._next_tasks_index do
			task = self._next_tasks[index]
			task.arguments = result
			self.loop:add_task(task)
		end
	end
end

local FutureSemaphore
do
	FutureSemaphore = setmetatable(
		{}, {__index=Future}
	)
	local meta = {__index = FutureSemaphore}

	--[[@
		@name new
		@desc Creates a new instance of FutureSemaphore: an object that will return many times later. This inherits from Future.
		@desc You can use EventLoop:await on it, but you can't use add_task.
		@param loop<EventLoop> The loop that the future belongs to
		@param quantity<int> The quantity of values that the object will return.
		@param obj?<table> The table to turn into a FutureSemaphore.
		@returns FutureSemaphore The FutureSemaphore object
		@struct {
			_is_future = true, -- used to denote that it is a Future object
			loop = EventLoop, -- the loop that the future belongs to
			quantity = quantity, -- the quantity of values that the object will return
			_done = 0, -- the quantity of values that the object has prepared
			_next_tasks = {}, -- the tasks that the future is gonna run once it is done
			_next_tasks_index = 0, -- the tasks table pointer
			result = nil or table, -- the Future result; if it is nil, the future is not completely done.
			_result = table -- the FutureSemaphore partial or complete result; if it is nil, no result was given in.
			cancelled = false -- whether the future is cancelled or not
			cancelled = false, -- whether the future is cancelled or not
			done = false -- whether the future is done or not
		}
	]]
	function FutureSemaphore.new(loop, quantity, obj)
		obj = Future(loop, obj)
		obj.quantity = quantity
		obj._done = 0
		obj._result = {}
		return setmetatable(obj, meta)
	end

	--[[@
		@name set_result
		@desc Sets the Future result and calls all the scheduled tasks
		@param result<table> A table (with no associative members) to set as the result. Can have multiple items.
		@param index<number> The index of the result. Can't be repeated.
	]]
	function FutureSemaphore:set_result(result, index)
		if self.done then
			error("The FutureSemaphore has already been done.", 2)
		elseif self.cancelled then
			error("The FutureSemaphore was cancelled.", 2)
		end

		if not self._result[index] then
			self._result[index] = result
			self._done = self._done + 1
		else
			error("The given semaphore spot is already taken.", 2)
		end

		if self._done == self.quantity then
			self.done = true
			self.result = self._result

			local task_result, task = {self.result}
			for _index = 1, self._next_tasks_index do
				task = self._next_tasks[_index]
				task.arguments = task_result
				self.loop:add_task(task)
			end
		end
	end
end

return Future, FutureSemaphore
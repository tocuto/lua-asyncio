local Future
do
	Future = {}
	local meta = {__index = Future}

	function Future.new(loop, obj)
		obj = obj or {}
		obj._is_future = true
		obj.loop = loop
		obj._next_tasks = {}
		obj._next_tasks_index = 0
		return setmetatable(obj, meta)
	end

	function Future:set_result(result)
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
	FutureSemaphore = {}
	local meta = {__index = FutureSemaphore}

	function FutureSemaphore.new(loop, quantity, obj)
		obj = obj or {}
		obj._is_future = true
		obj.loop = loop
		obj.quantity = quantity
		obj.result = {}
		obj._next_tasks = {}
		obj._next_tasks_index = 0
		obj.done = 0
		return setmetatable(obj, meta)
	end

	function FutureSemaphore:set_result(result, index)
		if not self.result[index] then
			self.result[index] = result
			self.done = self.done + 1
		else
			error("The given semaphore spot is already taken.", 2)
		end

		if self.done == self.quantity then
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
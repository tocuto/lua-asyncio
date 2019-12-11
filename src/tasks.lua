local Task
do
	local remove = table.remove
	local unpack = table.unpack
	local create = coroutine.create
	local resume = coroutine.resume
	local status = coroutine.status

	Task = {}
	local meta = {__index = Task}

	function Task.new(fnc, args, obj)
		obj = obj or {}
		obj.arguments = args
		obj.coro = create(fnc)
		obj.futures = {}
		obj.futures_index = 0
		return setmetatable(obj, meta)
	end

	function Task:run(loop)
		local data
		if self.arguments then
			data = {resume(self.coro, unpack(self.arguments))}
			self.arguments = nil
		else
			data = {resume(self.coro)}
		end

		if not self.cancelled then
			if status(self.coro) == "dead" then
				self.done = true
				if data[1] then
					local length = #self.futures
					if length > 0 or self._next_task then
						remove(data, 1)
					else
						return
					end

					local future
					for index = 1, length do
						future = self.futures[index]
						future.obj:set_result(data, future.index)
					end

					if self._next_task then
						self._next_task.arguments = data

						loop:add_task(self._next_task)
					end
				else
					error(data[2])
				end
			end
		end
	end

	function Task:add_future(future, index)
		self.futures_index = self.futures_index + 1
		self.futures[self.futures_index] = {obj=future, index=index}
	end
end

local function async(fnc)
	return function(...)
		return Task.new(fnc, {...}, {})
	end
end

return Task, async
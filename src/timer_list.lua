local TimerList
do
	local time = os.time

	TimerList = {}
	local meta = {__index = TimerList}

	function TimerList.new(obj)
		return setmetatable(obj or {}, meta)
	end

	function TimerList:add(timer)
		if not self.last then
			self.last = timer
		elseif self.last.when < timer.when then
			local current, last = self.last.previous, self.last
			while current and current.when < timer.when do
				current, last = current.previous, current
			end

			timer.previous, last.previous = current, timer
		else
			timer.previous = self.last
			self.last = timer
		end
	end

	function TimerList:run()
		local now, current = time(), self.last
		while current and current.when <= now do
			current:callback() -- gives the timer itself to the callback
			current = current.previous
		end
		self.last = current
	end
end

return TimerList
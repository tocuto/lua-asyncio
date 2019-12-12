local tasks = require "lua-asyncio/tasks"
local futures = require "lua-asyncio/futures"

local Task = tasks.Task
local Future = futures.Future

local Event
do
	Event = {}
	local meta = {__index = Event}

	--[[@
		@name new
		@desc Creates a new instance of Event
		@desc This is an object that notifies other tasks when it is set.
		@param loop<EventLoop> The EventLoop that the Event belongs to.
		@returns Event The Event object
		@struct {
			loop = loop, -- The EventLoop that the Event belongs to
			tasks = {}, -- The tasks that are waiting for the Event to be set
			tasks_index = 0, -- The tasks list pointer
			is_set = false -- Whether the event is set or not
		}
	]]
	function Event.new(loop, obj)
		obj = obj or {}
		obj.loop = loop
		obj.tasks = {}
		obj.tasks_index = 0
		return setmetatable(obj, meta)
	end

	--[[@
		@name wait
		@desc Return a task that, when awaited, will block until Event.is_set is true.
		@returns Task The task
	]]
	Event.wait = async(function(self)
		if self.is_set then return end

		self.tasks_index = self.tasks_index + 1
		self.tasks[self.tasks_index] = self.loop.current_task
		self.loop:stop_task_execution()
	end)

	--[[@
		@name set
		@desc Sets the event and releases every Event:wait() task.
	]]
	function Event:set()
		if self.is_set then return end
		self.is_set = true

		for index = 1, self.tasks_index do
			self.loop:add_task(self.tasks[index])
		end
	end

	--[[@
		@name clear
		@desc Clears (unset) the event, making every new Event:wait() task block again.
	]]
	function Event:clear()
		if not self.is_set then return end
		self.is_set = false

		self.tasks_index = 0
		self.tasks = {}
	end
end

return {
	Event = Event
}
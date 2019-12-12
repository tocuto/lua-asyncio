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
		@desc This is an object
		@param loop<EventLoop> The EventLoop that the Event belongs to.
		@returns Event The Event object
		@struct {
			loop = loop, -- The EventLoop that the Event belongs to
			future = loop:new_future(), -- A Future object
			is_set = false -- Whether the event is set or not
		}
	]]
	function Event.new(loop, obj)
		obj = obj or {}
		obj.loop = loop
		obj.future = loop:new_future()
		return setmetatable(obj, meta)
	end

	--[[@
		@name wait
		@desc Return a task that, when awaited, will block until Event.is_set is true.
		@returns Task The task
	]]
	Event.wait = async(function(self)
		if self.is_set then return end
		self.loop:await(self.future)
	end)

	--[[@
		@name set
		@desc Sets the event and releases every Event:wait() task.
	]]
	function Event:set()
		if self.is_set then return end
		self.is_set = true
		self.future:set_result({}, true)
	end

	--[[@
		@name clear
		@desc Clears (unset) the event, making every new Event:wait() task block again.
	]]
	function Event:clear()
		if not self.is_set then return end
		self.is_set = false
		self.future = self.loop:new_future()
	end
end
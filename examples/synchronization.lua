local asyncio = require "lua-asyncio"
local async = asyncio.async

local loop = asyncio.loops.EventLoop.new({}, 10, 10)
local lock = loop:new_object(asyncio.sync.Lock)
local event = loop:new_object(asyncio.sync.Event)

local shared_var

local shared_access = async(function()
	if shared_var then return end
	print("Acquiring lock...")
	loop:await(lock:acquire())
	-- Re-check if shared_var is still unexistent; since it could have changed
	-- while the task was acquiring the Lock.
	if shared_var then
		print("While acquiring, the var was set.")
		return lock:release()
	end
	print("Acquired.")

	loop:sleep(3)
	-- Sleeps so other vars try to acquire the lock.
	shared_var = "some value"

	print("Releasing...")
	lock:release()
	print("Released.")

	print("Notifying tasks...")
	event:set()
	print("Notified.")
end)

local event_waiter = async(function()
	print("Waiting event...")
	loop:await(event:wait())
	print("Received event. Shared variable value:", shared_var)
end)

loop:add_task(shared_access())
loop:add_task(shared_access())
loop:add_task(shared_access())

loop:add_task(event_waiter())
loop:add_task(event_waiter())
loop:add_task(event_waiter())

while true do
	loop:run()
end

-- As you know, EventLoop is not ordered just to make it faster
-- So, in this example, if you run it with OrderedEventLoop, the output order will be different.
--[[ OUTPUT OF THE PROGRAM:
Acquiring lock...
Acquiring lock...
Acquiring lock...
Waiting event...
Waiting event...
Waiting event...
Acquired.
Releasing...
Released.
Notifying tasks...
Notified.
Received event. Shared variable value:	some value
Received event. Shared variable value:	some value
While acquiring, the var was set.
Received event. Shared variable value:	some value
While acquiring, the var was set.
]]
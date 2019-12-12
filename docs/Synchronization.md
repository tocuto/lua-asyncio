# Methods
>### Lock.new ( loop, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The EventLoop that the Lock belongs to. |
>
>Creates a new instance of Lock<br>
>This is an object used to have exclusive access to shared resources.<br>
>If a task acquired it, no other task can acquire the object again until this one releases it
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Lock` | The Lock object |
>
>**Table structure**:
>```Lua
>{
>	loop = loop, -- The EventLoop that the Lock belongs to
>	tasks = {}, -- The Tasks objects that are waiting to acquire the Lock
>	tasks_append = 0, -- The current tasks list "append" pointer
>	tasks_give = 0, -- The current tasks list "give" pointer
>	is_locked = false -- Whether the lock is set or not
>}
>```
---
>### Lock.acquire ( self )
>
>Returns a task that, when awaited, will block until the lock is acquired.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Task` | The task |
>
---
>### Lock:release (  )
>
>Releases the lock and wakes up the next task waiting to acquire it, if any.
>
---
>### Event.new ( loop, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The EventLoop that the Event belongs to. |
>
>Creates a new instance of Event<br>
>This is an object that notifies other tasks when it is set.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Event` | The Event object |
>
>**Table structure**:
>```Lua
>{
>	loop = loop, -- The EventLoop that the Event belongs to
>	tasks = {}, -- The tasks that are waiting for the Event to be set
>	tasks_index = 0, -- The tasks list pointer
>	is_set = false -- Whether the event is set or not
>}
>```
---
>### Event.wait ( self )
>
>Return a task that, when awaited, will block until Event.is_set is true.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Task` | The task |
>
---
>### Event:set (  )
>
>Sets the event and releases every Event:wait() task.
>
---
>### Event:clear (  )
>
>Clears (unset) the event, making every new Event:wait() task block again.
>
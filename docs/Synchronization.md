# Methods
>### Event.new ( loop, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The EventLoop that the Event belongs to. |
>
>Creates a new instance of Event<br>
>This is an object
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
>	future = loop:new_future(), -- A Future object
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
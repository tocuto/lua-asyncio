# Methods
>### get_event_loop (  )
>
>Returns the event loop where the task is running on
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `EventLoop` | The EventLoop. |
>
---
>### EventLoop.new ( obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| obj | `table` | ✕ | The table to turn into an EventLoop. |
>
>Creates a new instance of EventLoop: an object that runs tasks concurrently (pseudo-paralellism)<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) EventLoop.tasks_index might be lower than the quantity of items in the EventLoop.tasks list. You must trust tasks_index.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) EventLoop.removed_index might be lower than the quantity of items in the EventLoop.removed list. You must trust removed_index.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) The tasks might run in a different order than the one they acquire once you run EventLoop:add_task
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `EventLoop` | The EventLoop. |
>
>**Table structure**:
>```Lua
>{
>	timers = TimerList, -- A list of the timers the EventLoop will handle
>	tasks = {}, -- The list of tasks the EventLoop is running
>	removed = {}, -- The list of indexes in the tasks list to remove
>	tasks_index = 0, -- The tasks list pointer
>	removed_index = 0, -- The removed list pointer
>	error_handler = nil -- The error handler. It must be a function (which receive the error and the task), and if it returns a Task it will be awaited.
>}
>```
---
>### EventLoop.timers_callback ( callback )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| callback | `Timer` | ✔ | The timer that is being executed |
>
>**@`callback` parameter's structure**:
>
>| Index | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| 	task | `Task` | ✔ | The task to execute. |
>
>This function is called when a timer executes. It adds the timer task to the EventLoop.<br>
>This function doesn't use all the Timer arguments. Passsing the ones listed here is enough.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) This function shouldn't be called by the user code, it should be called by timers only.
>
---
>### EventLoop.cancel_awaitable ( callback )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| callback | `Timer` | ✔ | The timer that is being executed |
>
>**@`callback` parameter's structure**:
>
>| Index | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| 	awaitable | `Future`, `Task` | ✔ | The awaitable to cancel. |
>
>This function is called when an awaitable times out.<br>
>This function doesn't use all the Timer arguments. Passsing the ones listed here is enough.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) This function shouldn't be called by the user code, it should be called by timers only.
>
---
>### EventLoop:sleep ( delay )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| delay | `number` | ✔ | The time to sleep |
>
>This function pauses the current task execution and resumes it after some time.
>
---
>### EventLoop:call_soon ( delay, task, no_future )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| delay | `number` | ✔ | The time to wait until the task can be appended |
>| task | `Task` | ✔ | The task to append |
>| no_future | `boolean` | ✕ | Either to cancel the creation or not a Future object that will return after the task ends. <sub>(default = false.)</sub> |
>
>This function appends the given task to the EventLoop list after some time.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Future` | Returns the Future object if no_future is false. |
>
---
>### EventLoop:sleep_until ( when )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| when | `number` | ✔ | The time when the task will be resumed |
>
>The same as EventLoop:sleep, but with an absolute time.
>
---
>### EventLoop:schedule ( when, task, no_future )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| when | `number` | ✔ | The time when the task can be appended |
>| task | `Task` | ✔ | The task to append |
>| no_future | `boolean` | ✕ | Either to cancel the creation or not a Future object that will return after the task ends. <sub>(default = false.)</sub> |
>
>The same as EventLoop:call_soon, but with an absolute time.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Future` | Returns the Future object if no_future is false. |
>
---
>### EventLoop:add_task ( task )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| task | `Task` | ✔ | The task to append |
>
>Adds a task to run on the next loop iteration.
>
---
>### EventLoop:new_object ( object, ... )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| object | `Future`, `Lock`, `Event`, `Queue` | ✔ | The object class |
>| vararg | `mixed` | ✔ | The object arguments |
>
>Creates a new asyncio object that belongs to this EventLoop
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `mixed` | The new object |
>
---
>### EventLoop:stop_task_execution (  )
>
>Pauses the task execution. This can be called from inside the task only.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) The task doesn't resume again if you don't append it back later. If you don't do it, this will just stop forever the task execution.
>
---
>### EventLoop:is_awaitable ( aw )
>
>Checks if an object is awaitable or not.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether the object is awaitable or not |
>
---
>### EventLoop:await ( aw )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| aw | `Future`, `Task` | ✔ | The awaitable to wait. |
>
>Awaits a Future or Task to complete. Pauses the current task and resumes it again once the awaitable is done.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `mixed` | The Future or Task return values. |
>
---
>### EventLoop:await_safe ( aw )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| aw | `Future`, `Task` | ✔ | The awaitable to wait. |
>
>Awaits a Future or Task to complete, but safely. Returns nil if an error happened.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `mixed` | The awaitable return values, or nil if it had an error. |
>
---
>### EventLoop:add_timeout ( aw, timeout )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| aw | `Future`, `Task` | ✔ | The awaitable to wait. |
>
>Adds a timeout for an awaitable. Basically it cancels the awaitable once the timeout is reached.
>
---
>### EventLoop:await_for ( aw, timeout )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| aw | `Future`, `Task` | ✔ | The awaitable to wait |
>| timeout | `number` | ✔ | The timeout |
>
>A shorthand method for add_timeout and await_safe.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `mixed` | The Future or Task return values. |
>
---
>### EventLoop:await_many ( ... )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| vararg | `Future`, `Task` | ✔ | The awaitables to wait |
>
>Awaits many awaitables at once. Runs them concurrently, and requires a FutureSemaphore object to do so.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `FutureSemaphore` | The FutureSemaphore that will result once every awaitable is done. |
>
---
>### EventLoop:run (  )
>
>Runs a loop iteration.
>
---
>### EventLoop:run_until_complete ( task )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| task | `Task` | ✔ | The task |
>
>Schedules the task, adds a future and runs the loop until the task is done.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `mixed` | The values the task returns |
>
---
>### EventLoop:handle_error ( task, index )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| task | `Task` | ✔ | The task |
>| index | `int` | ✔ | The task index in the list, to be removed later. |
>
>Handles a task error and calls EventLoop:remove_later
>
---
>### EventLoop:remove_later ( index )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| index | `int` | ✔ | The task to remove |
>
>Schedules a task removal
>
---
>### EventLoop:run_tasks (  )
>
>Runs the tasks in the list only.
>
---
>### EventLoop:remove_tasks (  )
>
>Removes the tasks that are waiting to be removed from the list.
>
---
>### OrderedEventLoop.new ( obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| obj | `table` | ✕ | The table to turn into an EventLoop. |
>
>Creates a new instance of OrderedEventLoop: the same as EventLoop but respecting the tasks order.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) This is different from EventLoop since here, tasks_index and the quantity of items of tasks match.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) EventLoop.removed_index might be lower than the quantity of items in the EventLoop.removed list. You must trust removed_index.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) The tasks orders is the one they acquire once you run OrderedEventLoop:add_task.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `OrderedEventLoop` | The OrderedEventLoop. |
>
>**Table structure**:
>```Lua
>{
>	timers = TimerList, -- A list of the timers the EventLoop will handle
>	tasks = {}, -- The list of tasks the EventLoop is running
>	removed = {}, -- The list of indexes in the tasks list to remove
>	tasks_index = 0, -- The tasks list pointer
>	removed_index = 0 -- The removed list pointer
>}
>```
---
>### OrderedEventLoop:remove_tasks (  )
>
>Removes the tasks that are waiting to be removed from the list.
>
---
>### LimitedEventLoop.new ( obj, runtime, reset )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| obj | `table`, `nil` | ✔ | The table to turn into an EventLoop. |
>| runtime | `int` | ✔ | The maximum runtime that can be used. |
>| reset | `int` | ✔ | How many time it needs to wait until the used runtime is resetted. |
>
>Creates a new instance of LimitedEventLoop: the same as EventLoop but with runtime limitations<br>
>This inherits from EventLoop
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `LimitedEventLoop` | The LimitedEventLoop. |
>
>**Table structure**:
>```Lua
>{
>	timers = TimerList, -- A list of the timers the EventLoop will handle
>	tasks = {}, -- The list of tasks the EventLoop is running
>	removed = {}, -- The list of indexes in the tasks list to remove
>	tasks_index = 0, -- The tasks list pointer
>	removed_index = 0, -- The removed list pointer
>	runtime = runtime, -- The maximum runtime
>	reset = reset, -- The reset interval
>	used = 0, -- The used runtime
>	initialized = 0, -- When was the last runtime reset
>	step = 0 -- The iteration step (0 -> needs to run timers, 1 -> needs to run tasks, 2 -> needs to remove tasks)
>}
>```
---
>### LimitedEventLoop:can_run ( now )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| now | `int` | ✔ | How many runtime is being used and not counted in LimitedEventLoop.used |
>
>Checks if the EventLoop can run something.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether it can run something or not |
>
---
>### LimitedEventLoop:run (  )
>
>Runs (or partially runs) a loop iteration if it is possible.
>
---
>### MixedEventLoop ( eventloop, ... )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| eventloop | `table` | ✔ | The table to turn into the mix |
>| vararg | `EventLoop` | ✔ | The classes to mix |
>
>Creates a new object which is a mix of any EventLoop's variants.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `EventLoop` | The mixed event loop. |
>
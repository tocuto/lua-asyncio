# Methods
>### Task.new ( fnc, args, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| fnc | `function` | ✔ | The function that the task will execute. It can have special EventLoop calls like await, sleep, call_soon... |
>| args | `table` | ✔ | A table (with no associative members) to set as the arguments. Can have multiple items. |
>| obj | `table` | ✕ | The table to turn into a Task. |
>
>Creates a new instance of Task: a function that can be run by an EventLoop<br>
>If you await a Task, it will return the raw function returned values.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) If you safely await it, it might return nil, and you need to check its error manually.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Task` | The task object. |
>
>**Table structure**:
>```Lua
>{
>	arguments = {}, -- The arguments to give the function the next time Task:run is executed.
>	coro = coroutine_function, -- The coroutine wrapping the task function.
>	futures = {}, -- A list of futures to set the result after the task is done.
>	futures_index = 0, -- The futures list pointer
>	stop_error_propagation = false, -- Whether to stop the error propagation or not
>	error = false or string, -- The error, if any
>	done = false, -- Whether the task is done or not
>	cancelled = false, -- Whether the task is cancelled or not
>	timer = nil or Timer, -- nil if the task is not scheduled, a Timer object otherwise.
>	ran_once = false -- Whether the task did run (or at least partially run)
>}
>```
---
>### Task:cancel (  )
>
>Cancels the task, and if it is awaiting something, cancels the awaiting object too.
>
---
>### Task:run ( loop )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The loop that will run this part of the task |
>
>Runs the task function
>
---
>### Task:add_future ( future, index )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| future | `Future` | ✔ | The future object. Can be a variant too. |
>| index | `int` | ✕ | The index given to the future object (used only with FutureSemaphore) |
>
>Adds a future that will be set after the task runs.
>
---
>### async ( fnc )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| fnc | `function` | ✔ | The function |
>
>A decorator function that will create a new task object with the function passed it everytime it is called.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `function` | The wrapper. |
>
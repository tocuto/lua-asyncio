# Methods
>### Future.new ( loop, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The loop that the future belongs to |
>| obj | `table` | ✕ | The table to turn into a Future. |
>
>Creates a new instance of Future: an object that will return later. You can use EventLoop:await on it, but you can't use EventLoop:add_task.<br>
>If you await it, it will return the :set_result() unpacked table. If you set the result to {"a", "b", "c"}, it will return "a", "b", "c".<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) If you safely await it, it will return nil and you need to manually check its error.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Future` | The Future object |
>
>**Table structure**:
>```Lua
>{
>	_is_future = true, -- used to denote that it is a Future object
>	loop = EventLoop, -- the loop that the future belongs to
>	_next_tasks = {}, -- the tasks that the Future is gonna run once it is done
>	_next_tasks_index = 0, -- the tasks table pointer
>	futures = {}, -- the futures to trigger after this is done
>	futures_index = 0, -- the futures pointer
>	result = nil or table, -- the Future result; if it is nil, it didn't end yet.
>	error = false or string, -- whether the future has thrown an error or not
>	cancelled = false, -- whether the future is cancelled or not
>	done = false -- whether the future is done or not
>}
>```
---
>### Future:cancel (  )
>
>Cancels the Future
>
---
>### Future:add_future ( future, index )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| future | `Future` | ✔ | The future object. Can be a variant too. |
>| index | `int` | ✕ | The index given to the future object (used only with FutureSemaphore) |
>
>Adds a future that will be set after this one is done.
>
---
>### Future:set_result ( result, safe )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| result | `table` | ✔ | A table (with no associative members) to set as the result. Can have multiple items. |
>| safe | `boolean` | ✕ | Whether to cancel the error if the result can't be set. <sub>(default = false.)</sub> |
>
>Sets the Future result and calls all the scheduled tasks
>
---
>### Future:set_error ( result, index, safe )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| result | `string` | ✔ | A string to set as the error message. |
>| safe | `boolean` | ✕ | Whether to cancel the error if the result can't be set. <sub>(default = false.)</sub> |
>
>Sets the Future error and calls all the scheduled tasks
>
---
>### FutureSemaphore.new ( loop, quantity, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The loop that the future belongs to |
>| quantity | `int` | ✔ | The quantity of values that the object will return. |
>| obj | `table` | ✕ | The table to turn into a FutureSemaphore. |
>
>Creates a new instance of FutureSemaphore: an object that will return many times later. This inherits from Future.<br>
>You can use EventLoop:await on it, but you can't use add_task.<br>
>If you await it, it will return a table where you can get all the appended values with their respective indexes.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) FutureSemaphore will never propagate an error, instead, it will append it to the result as a string.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `FutureSemaphore` | The FutureSemaphore object |
>
>**Table structure**:
>```Lua
>{
>	_is_future = true, -- used to denote that it is a Future object
>	loop = EventLoop, -- the loop that the future belongs to
>	quantity = quantity, -- the quantity of values that the object will return
>	_done = 0, -- the quantity of values that the object has prepared
>	_next_tasks = {}, -- the tasks that the future is gonna run once it is done
>	_next_tasks_index = 0, -- the tasks table pointer
>	result = nil or table, -- the Future result; if it is nil, the future is not completely done.
>	_result = table -- the FutureSemaphore partial or complete result; if it is nil, no result was given in.
>	cancelled = false -- whether the future is cancelled or not
>	cancelled = false, -- whether the future is cancelled or not
>	done = false -- whether the future is done or not
>}
>```
---
>### FutureSemaphore:set_result ( result, safe, index )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| result | `table` | ✔ | A table (with no associative members) to set as the result. Can have multiple items. |
>| safe | `boolean` | ✔ | Whether to cancel the error if the result can't be set. |
>| index | `number` | ✔ | The index of the result. Can't be repeated. |
>
>Sets a FutureSemaphore result and calls all the scheduled tasks if it is completely done
>
---
>### FutureSemaphore:set_error ( result, safe, index )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| result | `string` | ✔ | A string to set as the error message. |
>| safe | `boolean` | ✔ | Whether to cancel the error if the result can't be set. |
>| index | `number` | ✔ | The index of the result. Can't be repeated. |
>
>Sets a FutureSemaphore error and calls all the scheduled tasks if it is completely done
>
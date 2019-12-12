# Methods
>### Queue.new ( loop, maxsize, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The EventLoop the Queue belongs to |
>| maxsize | `int` | ✕ | The queue max size. <sub>(default = 0)</sub> |
>| obj | `table` | ✕ | The table to turn into a Queue. |
>
>Creates a new instance of Queue<br>
>This is a FIFO Queue (first in, first out). If maxsize is less than or equal to zero, the queue size is infinite.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) Queue.size might be an approximated value some times (on purpose for internal reasons). Use Queue.real_size if you want to get the real queue size.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Queue` | The Queue object |
>
>**Table structure**:
>```Lua
>{
>	loop = loop, -- The EventLoop the Queue belongs to
>	maxsize = maxsize, -- The queue max size
>	waiting_free = {}, -- The sleeping tasks that are waiting for a free spot in the queue
>	waiting_free_append = 0, -- The "waiting_free append pointer"
>	waiting_free_give = 0, -- The "waiting_free give pointer"
>	waiting_item = {}, -- The sleeping tasks that are waiting for an item in the queue
>	waiting_item_append = 0, -- The "waiting_item append pointer"
>	waiting_item_give = 0, -- The "waiting_item give pointer"
>	size = 0, -- The queue approximated size (±1)
>	real_size = 0 -- The queue real size
>}
>```
---
>### Queue:full (  )
>
>Checks if the queue is full or not
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether the queue is full or not |
>
---
>### Queue:empty (  )
>
>Checks if the queue is empty or not
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether the queue is empty or not |
>
---
>### Queue:trigger_add (  )
>
>Wakes up a Queue:get task that is waiting for an item to be added.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) This method should never be called by the user code.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether a task was triggered or not |
>
---
>### Queue:trigger_remove (  )
>
>Wakes up a Queue:add task that is waiting for an item to be removed.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) This method should never be called by the user code.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether a task was triggered or not |
>
---
>### Queue:add_nowait ( item, safe )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| item | `table` | ✔ | The item to add |
>| safe | `boolean` | ✕ | Whether to cancel throwing an error if the queue is full <sub>(default = false)</sub> |
>
>Adds an item to the queue without blocking.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether the item was added or not (if safe is false, this will always be true) |
>
---
>### Queue.add ( self, item )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| item | `table` | ✔ | The item to add |
>
>Returns a task that, when awaited, will try to add the item to the queue, and if it cant, it will block until it can.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Task` | The task. |
>
---
>### Queue:get_nowait ( safe )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| safe | `boolean` | ✕ | Whether to cancel throwing an error if the queue is empty <sub>(default = false)</sub> |
>
>Gets an item from the queue without blocking.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean`, `table` | `false` if the queue is empty and `safe` is `false`, the item (`table`) otherwise. |
>
---
>### Queue.get ( self )
>
>Returns a task that, when awaited, will try to get an item from the queue, and if it cant, it will block until it can.<br>
>The task always returns a `table`, which is the item.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Task` | The task |
>
---
>### LifoQueue.new ( loop, maxsize, obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| loop | `EventLoop` | ✔ | The EventLoop the Queue belongs to |
>| maxsize | `int` | ✕ | The queue max size. <sub>(default = 0)</sub> |
>| obj | `table` | ✕ | The table to turn into a Queue. |
>
>Creates a new instance of LifoQueue (which inherits from Queue)<br>
>This is a LIFO Queue (last in, first out). If maxsize is less than or equal to zero, the queue size is infinite.<br>
>![/!\\](https://i.imgur.com/HQ188PK.png) Queue.size might be an approximated value some times (on purpose for internal reasons). Use Queue.real_size if you want to get the real queue size.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Queue` | The Queue object |
>
>**Table structure**:
>```Lua
>{
>	loop = loop, -- The EventLoop the Queue belongs to
>	maxsize = maxsize, -- The queue max size
>	waiting_free = {}, -- The sleeping tasks that are waiting for a free spot in the queue
>	waiting_free_append = 0, -- The "waiting_free append pointer"
>	waiting_free_give = 0, -- The "waiting_free give pointer"
>	waiting_item = {}, -- The sleeping tasks that are waiting for an item in the queue
>	waiting_item_append = 0, -- The "waiting_item append pointer"
>	waiting_item_give = 0, -- The "waiting_item give pointer"
>	size = 0, -- The queue approximated size (±1)
>	real_size = 0 -- The queue real size
>}
>```
---
>### LifoQueue:add_nowait ( item, safe )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| item | `QueueItem` | ✔ | The item to add |
>| safe | `boolean` | ✕ | Whether to cancel throwing an error if the queue is full <sub>(default = false)</sub> |
>
>Adds an item to the queue without blocking.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `boolean` | Whether the item was added or not (if safe is false, this will always be true) |
>
---
>### LifoQueue.add ( self, item )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| item | `QueueItem` | ✔ | The item to add |
>
>Returns a task that, when awaited, will try to add the item to the queue, and if it cant, it will block until then.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Task` | The task. |
>
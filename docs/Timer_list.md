# Methods
>### TimerList.new ( obj )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| obj | `table` | ✕ | The table to turn into a TimerList. |
>
>Creates a new instance of TimerList.
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `TimerList` | The new TimerList object. |
>
>**Table structure**:
>```Lua
>{
>	last = Timer -- the last timer (the one that must trigger before all the others). Might be nil.
>}
>```
---
>### TimerList:add ( timer )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| timer | `Timer` | ✔ | The timer to add. |
>
>**@`timer` parameter's structure**:
>
>| Index | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| 	callback | `function` | ✔ | The callback function. |
>| 	when | `int` | ✔ | When it will be executed. |
>
>Adds a timer to the list.<br>
>`timer.callback` will receive the timer as the unique argument, so you can add more values here
>
>**Returns**:
>
>| Type | Description |
>| :-: | - |
>| `Timer` | The timer you've added |
>
---
>### TimerList:run (  )
>
>Runs the timers that need to be run.
>
---
>### TimerList:remove ( timer )
>| Parameter | Type | Required | Description |
>| :-: | :-: | :-: | - |
>| timer | `Timer` | ✔ | The timer to remove. |
>
>Removes a timer from the list.
>
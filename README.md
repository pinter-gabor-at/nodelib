# Library - NodeMCU, ESP12 - in Lua

A collection of useful things I usually upload into LFS. Most have a xxx_test companion that tests, and demostrates, and documents most of their functions.


## \_strings

Preloads common strings into ROM. It is not callable.


## lfsinit

Insert this line into your init.lua, and it will make access to LFS modules a little bit easier:

```lua
pcall(node.flashindex("lfsinit"))
```

## ESP12

Defines the names of ESP12 pins.

```lua
-- Regular pins
ESP12.GPIO0
ESP12.GPIO1
ESP12.GPIO2
ESP12.GPIO3
ESP12.GPIO4
ESP12.GPIO5
ESP12.GPIO9
ESP12.GPIO10
ESP12.GPIO12
ESP12.GPIO13
ESP12.GPIO14
ESP12.GPIO15
ESP12.GPIO16

-- and the blue LED, connected to GPIO2
ESP12.BLUELED
```


## led

Make access to the blue LED of ESP12 a bit more comfortable.

```lua
-- Set LED on.
function led.on()
    
-- Set LED off.
function led.off()
    
-- Set LED state
-- false or 0 =OFF, true and not 0 =ON
function led.setstate()
    
-- Get LED state
-- false=OFF, true=ON
function led.getstate()
```


## ledpattern

Create repeated patterns on the blue LED, or on any other LED like pin or pins, of the ESP12 easily. Quite often an LED, or a buzzer, is the only visible, or audible, indicator of an embedded ESP12 based application.

```lua
-- Pattern
-- It can be either a table, or a string.
-- Table items are passed 'as is' to setstate().
-- String characters ' ', '0' and '_' are translated to 0=OFF,
-- everything else is passed by its numeric code to setstate().
ledpattern.pattern = ""

-- Set interval between items in ms
-- The default is 100 ms.
function ledpattern.setinterval(value)

-- Rendering function
-- The default is led.setstate, but it can be replaced by anything similar.
ledpattern.setstate = led.setstate

-- Stop creating pattern
function ledpattern.stop()

-- Start creating pattern
function ledpattern.start()

-- Start or stop
--  state=true to start, state=false to stop
function ledpattern.run(state)
```

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA, pattern branch](https://gitlab.com/pintergabor/blinky/tree/pattern).


## morsetoblinky

Some people find it easier to define patterns using the conventional dot-dash-space notation 
of the Morse code. This notation not only makes writing patterns easier, it makes them shorter too.

```lua
-- Convert morse code to blinky code, that can be used to
-- create LED patterns with the ledtatterns module.
function morsetoblinky.toblinky(morse)
```

This would translate the `".--. .. -. - . .-.   --. .- -... --- .-.     "` pattern to the much longer `"- --- --- -   - -   --- -   ---   -   - --- -       --- --- -   - ---   --- - - -   --- --- ---   - --- -         "` blinky pattern.

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## texttomorse

An even more compact way of defining blinking patterns is to translate plain text to Morse notation and then to blinky notation. Some people even understand Morse code even without the aid of a computer.

```lua
-- Convert text to morse code
function texttomorse.tomorse(text)
```	

This would translate the `"PINTER GABOR  "` pattern to the pattern shown in the previous example.

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## stmr

The [built-in tmr module](https://nodemcu.readthedocs.io/en/master/en/modules/tmr/) of NodeMCU is fine for almost all purposes. You can create all sorts of timers up to 1:54:30.947, with millisecond resolution.

But sometimes we need extra long times, and we do not need the millisecond resolution.

Second timer, *stmr* implements the following functions:

```lua
-- Create a new second timer
function stmr.create()

-- The created second timer will have similar methods to the built-in tmr
function t:alarm(interval, mode, func)
function t:interval(interval)
function t:register(interval, mode, func)
function t:start()
function t:stop()
function t:unregister()
```

They have exactly the same interface as the object oriented interface of the [built-in tmr module](https://nodemcu.readthedocs.io/en/master/en/modules/tmr/), except that interval is in seconds and not in milliseconds.

The maximum value for interval is the largest integer that can be exactly represented. Assuming double precision IEEE 754 standard for floating-point numbers, it is 2^53 seconds, which is approximately 6.8 billion years, longer than the age of planet Earth.

There are two additional, rarely used, functions:

```lua
-- Base tick can be changed
-- 'tick' is in ms. The default value is 1000ms.
-- This affects ALL second timers, immediately
function stmr.setbasetick(tick)

-- Explicitly destroy all second timers, if they is no longer needed anywhere to save resources.
function stmr.destroy()
```

**Example**

```lua
local stmr = require("stmr.lua")
stmr.create():alarm(3600, tmr.ALARM_SINGLE, function()
    print("There is life after one hour!")
end)
```

For more information, please see [Second timer - Create long period timers on ESP12F - in LUA](https://gitlab.com/pintergabor/stmr).


## wlistsimple

List available networks in a simple form.

```lua
-- List available networks in a simple form
-- Call callback, when done
function wlistsimple.listap(callback)
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## wlistfancy

List available networks in a fancy form.

```lua
-- List available networks in a fancy form
-- Call callback, when done
function wlistfancy.listap(callback)
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## wrange

Create list of known networks in range, ordered by signal strength, modified by preference.

```lua
-- Create list of known networks in range,
-- ordered by signal strength, modified by preference.
--   known = {{pattern, pwd, pref}, ...}
--     pattern is a lua pattern to match actual SSIDs.
--   callback = callback({{ssid, bssid, pwd, rssi, pref}, ...}).
function wrange.getlist(known, callback)

-- Print list
function wrange.printlist(list)
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## wconnect

Connect to a network and get IP.

```lua
-- Connect to a network.
--   t = {ssid, bssid, pwd}
--   callback({IP, netmask, gateway}) = result, or nil on failure.
function wconnect.connect(t, callback)
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## wresolve

Resolve a nem to IP address.

```lua
-- Resolve a name
--   name = the name to resolve
--   callback(ip) = the IP, or nil, if it cannot be resolved
function wresolve.resolve(name, callback)
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## whttp

Execute a http request, possibly to multiple URLs.

```lua
-- Encapsulate http.get()
function whttp.get(url, headers, callback)

-- Similar to get, but urls is a list of urls
function whttp.mget(urls, headers, callback)
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## connect

Keep connected to the best network in range and get the same data repeatedly.

```lua
-- Set interval between items in ms
-- The default is 100 ms.
function connect.setinterval(value)

-- Known networks
-- {{pattern, pwd, pref}, ...}
--   pattern is a lua pattern to match actual SSIDs.
connect.known

-- List of alternative URLs
-- All should contain the same data, but might be accessible
-- at different times, and through different SSIDs.
connect.urls

-- Called after getting the data
-- callback = callback(data)
--   data is the data we got
connect.callback = nil

-- Start
-- It is possible to stop the cycle cleanly in callback by calling 'stop'
function connect.start()

-- Stop
-- It should be called in the callback.
function connect.stop()
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## utils

When lists are too long for a for loop to print ...

```lua
-- List globals
-- Call callback when done.
function utils.globals(callback)

-- Strings
-- Call callback when done.
--   r = "RAM" or "ROM"
function utils.strings(r, callback)

-- Print SPIFFS info
function utils.dirinfo()

-- List the contents of the SPIFFS
-- Call callback when done.
function utils.dir(callback)

-- Print LFS info
function utils.lfsdirinfo()

-- List the contents of the LFS
-- Call callback when done.
function utils.lfsdir(callback)
```	

For more information, please see [Blinky with a twist - Blink a LED connected to GPIO2 of ESP12F - in LUA](https://gitlab.com/pintergabor/blinky).


## testutil

Help writing asynchronous tests.

```lua
-- Callback at the end
testutil.callback

-- At the end of the test, execute callback.
function testutil.endtest()
```	

All modules in this library have a xxx_test companion. All these start the test asynchronously and return almost immediately.
If the test is started with assert(loadfile("xxx_test.lua"))(callback), callback is called at the end of the test.
Unfortunately dofile("xxx_test.lua") cannot pass parameters to the called test.

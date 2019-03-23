-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


-- Turn blue LED on and off
local M = dofile("led.lua")
node.task.post(function()
	print("\nBlue LED ON")
	M.on()
end)
tmr.create():alarm(3000, tmr.ALARM_SINGLE, function()
	print("Blue LED OFF")
	M.off()
	return T.endtest(true)
end)

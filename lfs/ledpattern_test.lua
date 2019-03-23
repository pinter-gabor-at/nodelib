-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


local M = dofile("ledpattern.lua")
node.task.post(function()
	print("\nBlink blue LED for 5 seconds")
	M.pattern = "010110111"
	M.start()
end)
tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()
	print("Done")
	M.stop()
	return T.endtest(true)
end)

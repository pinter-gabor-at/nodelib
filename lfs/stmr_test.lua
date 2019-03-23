-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


-- Normally we would use 'require', and that will keep it 
-- loaded, but for the test we need it only temporarily.
local M = dofile("stmr.lua")
local t1 = M.create()
t1:alarm(1, tmr.ALARM_AUTO, function()
	print("Tick 1")
end)
local t2 = M.create()
t2:alarm(2, tmr.ALARM_SEMI, function()
	print("Tick 2")
end)
M.create():alarm(5, tmr.ALARM_SINGLE, function()
	print("After 5 seconds: End of tests")
	t1:unregister()
	t2:unregister()
	-- We no longer need it
	M.destroy()
	T.endtest(true)
end)

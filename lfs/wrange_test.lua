-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


local M = dofile("wrange.lua")
node.task.post(function()
	print("\nOpen networks and PINTER* networks in range:")
	M.getlist(
		{
			{pattern="^PINTER%-TEST", pwd="password", pref=10},
			{pattern="^PINTER", pwd="password", pref=5},
			{pattern=""},
		},
		function(t)
			M.printlist(t)
			T.endtest(true)
		end)
end)

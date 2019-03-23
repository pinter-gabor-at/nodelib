-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


local M = dofile("wlistsimple.lua")
node.task.post(function()
	print("\nAccessible networks in simple form:")
	M.listap(function()
		print("\nDone")
		T.endtest(true)
	end)
end)

-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


-- It is always successfull
node.task.post(function()
	print("\nThere is nothing to test.")
	return T.endtest(true)
end)

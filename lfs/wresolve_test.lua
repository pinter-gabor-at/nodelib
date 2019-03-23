-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


local M = dofile("wresolve.lua")
node.task.post(function()
	print("\nTrying to resolve www.pintergabor.eu.")
	M.resolve(
		"www.pintergabor.eu",
		function(ip)
			if ip then
				T.endtest(true, "IP: " .. ip)
			else
				T.endtest(false, "Failed")
			end
		end)
end)

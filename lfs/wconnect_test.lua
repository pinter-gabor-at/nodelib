-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


local M = dofile("wconnect.lua")
node.task.post(function()
	print("\nTrying to connect to the PINTER-TEST network.")
	M.connect(
		{ssid="PINTER-TEST", pwd="password"},
		function(t)
			if t then
				T.endtest(true, "IP: " .. t.IP)
			else
				T.endtest(false, "Failed")
			end
		end)
end)

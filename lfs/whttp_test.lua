-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


local M = dofile("whttp.lua")
node.task.post(function()
	print("\nTrying to GET something.")
	M.mget(
		{
			"http://192.168.0.1",
			"http://www.pintergabor.eu",
		},
		nil,
		function(url, status, data)
			if not url or status < 0 then
				T.endtest(false, "Failed")
			else
				T.endtest(true, url .. "\n---\n" .. data)
			end
		end)
end)

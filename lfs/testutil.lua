-- Test utilities

-- Module start
local M = {}


-- Callback at the end
M.callback = nil


-- At the end of the test, execute callback.
function M.endtest(...)
	local ok, msg = ...
	if msg then
		-- Message
		print(msg)
	end
	if M.callback then
		return node.task.post(function()
			-- Return true, and optional success message, on success,
			-- false or nil, and error message, on failure.
			M.callback(ok, msg)
		end)
	end
end


-- Module end
return M

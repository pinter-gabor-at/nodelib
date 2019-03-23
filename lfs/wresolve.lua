-- Resolve a name

-- Module start
local M = {}


-- Resolve a name
--   name = the name to resolve
--   callback(ip) = the IP, or nil, if it cannot be resolved
function M.resolve(name, callback)

	-- Timeout counter
	local totmr

	-- End
	-- rt is either {ip, netmask, gateway},
	-- or nil, if there is no IP
	local function docallback(ip)
		-- Clean up
		if totmr then
			totmr:unregister()
			totmr = nil
			-- Callback
			if callback then
				node.task.post(function()
					return callback(ip)
				end)
			end
		end
	end

	-- Timeout
	local function timeout()
		-- Failure
		return docallback()
	end

	-- Resolved
	local function resolved(sk, ip)
		-- Success or failure
		return docallback(ip)
	end

	-- Create and start the timeout counter
	totmr = tmr.create()
	totmr:alarm(60000, tmr.ALARM_SEMI, timeout)
	-- Try to resolve name
	net.dns.resolve(name, resolved)
end


-- Module end
return M

-- Keep connected to the best network in range
-- and get the same data repeatedly

-- Includes
local wrange = require("wrange")
local wconnect = require("wconnect")
local whttp = require("whttp")

-- Module start
local M = {}


-- Index
local index


-- Timer
local itmr


-- Interval between accesses in ms
local interval = 60000


-- Set interval between items in ms
-- The default is 60000 ms.
function M.setinterval(value)
	interval = value
	if itmr then
		itmr:interval(value)
	end
end


-- Known networks
-- {{pattern, pwd, pref}, ...}
--   pattern is a lua pattern to match actual SSIDs.
M.known = {}


-- List of alternative URLs
-- All should contain the same data, but might be accessible
-- at different times, and through different SSIDs.
M.urls = {}


-- Called after getting the data
-- callback = callback(data)
--   data is the data we got
M.callback = nil


-- Start
-- It is possible to stop the cycle cleanly in callback by calling 'stop'
function M.start()

	-- Execute callback and restart timer
	local function docallback(data)
		if M.callback then
			node.task.post(function()
				M.callback(data)
				if itmr then
					itmr:start()
				end
			end)
		elseif itmr then
			itmr:start()
		end
	end

	-- Iterator, defined later
	local iter

	-- Get PATTERN
	-- Callback of whttp.mget(..., callback(url, status, data))
	--   url = url of the data
	--   status = regular HTTP status code, or -1 on error
	--   data = body
	local function getdata(url, status, data)
		if url and (0 <= status) then
			print("Got data from " .. url)
			-- Success
			docallback(data)
		else
			-- Next
			node.task.post(iter)
		end
	end

	-- Get connected
	--   t = {IP, netmask, gateway}
	local function getip(t)
		if t then
			print("Got IP: " .. t.IP)
			whttp.mget(M.urls, nil, getdata)
		else
			-- Next
			node.task.post(iter)
		end
	end

	-- Callback of wrange.getlist(..., callback(t))
	--   t = {{ssid, bssid, pwd, rssi, pref}, ...}
	local function process(t)
		local i

		iter = function()
			i = i + 1
			if i <= #t then
				print("Connecting to " .. t[i].ssid)
				wconnect.connect(t[i], getip)
			else
				-- End of the list, and no result
				docallback()
			end
		end

		-- Start evaluating the first
		i = 0
		node.task.post(iter)
	end

	-- Get list of known networks in range, ordered by preference
	local function geturlsdata()
		wrange.getlist(M.known, process)
	end

	-- Get data now
	geturlsdata()
	-- and then do it repeatedly
	itmr = tmr.create()
	itmr:register(M.interval, tmr.ALARM_SEMI, geturlsdata)
end


-- Stop
-- It should be called in the callback.
function M.stop()
	if itmr then
		itmr:unregister()
		itmr = nil
	end
end


-- Module end
return M

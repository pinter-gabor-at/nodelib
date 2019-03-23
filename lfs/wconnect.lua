-- Connect to a network and get IP

-- Module start
local M = {}


-- Connect to a network.
--   t = {ssid, bssid, pwd}
--   callback({IP, netmask, gateway}) = result, or nil on failure.
function M.connect(t, callback)

	-- Timeout counter
	local totmr

	-- End
	-- rt is either {ip, netmask, gateway},
	-- or nil, if there is no IP
	local function docallback(rt)
		-- Clean up
		wifi.eventmon.unregister(
			wifi.eventmon.STA_DISCONNECTED)
		wifi.eventmon.unregister(
			wifi.eventmon.STA_GOT_IP)
		if totmr then
			totmr:unregister()
			totmr = nil
			-- Callback
			if callback then
				node.task.post(function()
					return callback(rt)
				end)
			end
		end
	end

	-- Callback of totmr:alarm(..., callback())
	local function timeout()
		-- Failure
		docallback()
	end

	-- Callback of wifi.eventmon.register(
	--     wifi.eventmon.STA_GOT_IP, callback(t))
	local function gotip(t)
		-- Success
		docallback(t)
	end

	-- Callback of wifi.eventmon.register(
	--     wifi.eventmon.STA_DISCONNECTED, callback(t))
	local function disconnected(t)
		if t.reason == wifi.eventmon.reason.NO_AP_FOUND or
		   t.reason == wifi.eventmon.reason.AUTH_EXPIRE or 
		   t.reason == wifi.eventmon.reason.AUTH_FAIL then
			-- Failure
			docallback()
		end 
	end

	-- Create and start the timeout counter
	totmr = tmr.create()
	totmr:alarm(60000, tmr.ALARM_SEMI, timeout)
	-- Check if we are already connected to this network
	local ssid, _, _, bssid = wifi.sta.getconfig()
	local IP, netmask, gateway = wifi.sta.getip()
	if ssid==t.ssid and bssid==t.bssid and IP then
		docallback({IP=IP, netmask=netmask, gateway=gateway})
	else
		-- Register WIFI callbacks
		wifi.eventmon.register(
			wifi.eventmon.STA_DISCONNECTED, disconnected)
		wifi.eventmon.register(
			wifi.eventmon.STA_GOT_IP, gotip)
		-- Try to connect
		wifi.sta.config({
			ssid=t.ssid, bssid=t.bssid, pwd=t.pwd,
			save=false, auto=false,
		})
		wifi.sta.connect()
	end
end


-- Module end
return M

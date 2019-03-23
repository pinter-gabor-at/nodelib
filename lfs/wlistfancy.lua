-- List available networks

-- Module start
local M = {}


-- List available networks in a fancy form
-- Call callback, when done
function M.listap(callback)

	-- Callback of wifi.sta.getap()
	local function listfancy(t)
		-- List
		print("\nSSID                             BSSID              RSSI AUTH CH")
		for bssid, v in pairs(t) do
			local ssid, rssi, authmode, channel =
				string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
			print(string.format("%-32s %-18s %3d %2d %5d",
				ssid, bssid, rssi, authmode, channel))
		end
		-- Execute the callback
		if callback then
			node.task.post(callback)
		end
	end

	-- Scanning works in station mode only
	wifi.setmode(wifi.STATION)
	-- Scan, and when done, list
	wifi.sta.getap(1, listfancy)
end


-- Module end
return M

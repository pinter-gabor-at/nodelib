-- List available networks in simple form

-- Module start
local M = {}


-- List available networks in a simple form
-- Call callback, when done
function M.listap(callback)

	-- Callback of wifi.sta.getap()
	local function listsimple(t)
		-- List
		print("\nBSSID : SSID,RSSI,AUTH,CH")
		for k, v in pairs(t) do
			print(k .. " : " .. v)
		end
		-- Execute the callback
		if callback then
			node.task.post(callback)
		end
	end

	-- Scanning works in station mode only
	wifi.setmode(wifi.STATION)
	-- Scan, and when done, list
	wifi.sta.getap(1, listsimple)
end


-- Module end
return M

-- LED control

-- Includes
local ESP12 = require("ESP12")

-- Module start
local M = {}


-- Set LED ON
function M.on()
	gpio.mode(ESP12.BLUELED, gpio.OUTPUT)
	gpio.write(ESP12.BLUELED, 0)
end


-- Set LED off
function M.off()
	gpio.mode(ESP12.BLUELED, gpio.OUTPUT)
	gpio.write(ESP12.BLUELED, 1)
end


-- Set LED state
-- false or 0 =OFF, true and not 0 =ON
function M.setstate(state)
	if state and state ~= 0 then
		M.on()
	else
		M.off()
	end
end


-- Get LED state
-- false=OFF, true=ON
function M.getstate()
	return gpio.read(ESP12.BLUELED) == 0
end


-- Module end
return M

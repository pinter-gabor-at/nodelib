-- ESP12E and ESP12F pin definitions

-- Module start
local M = {
	-- Pins
	GPIO16 =  0,
	GPIO5  =  1,
	GPIO4  =  2,
	GPIO0  =  3,
	GPIO2  =  4,
	GPIO14 =  5,
	GPIO12 =  6,
	GPIO13 =  7,
	GPIO15 =  8,
	GPIO3  =  9,
	GPIO1  = 10,
	GPIO9  = 11,
	GPIO10 = 12,
}

-- Blue LED
-- 1=OFF, 0=ON
M.BLUELED = M.GPIO2

-- Module end
return M

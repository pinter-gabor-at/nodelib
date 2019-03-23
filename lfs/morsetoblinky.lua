-- morse to blinky conversion table

-- Module start
local M = {}


-- Translation table
local xlat = {
	["."] = "- ",
	["-"] = "--- ",
	[" "] = "  ",
}


-- Convert morse code to blinky code
function M.toblinky(morse)
	local blinky = ""
	for i = 1, #morse do
		local m = string.sub(morse, i, i)
		local b = xlat[m]
		if b then
			blinky = blinky .. b
		end
	end
	return blinky
end


-- Module end
return M

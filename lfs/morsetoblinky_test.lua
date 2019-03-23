-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


-- Convert a pattern
local M = dofile("morsetoblinky.lua")
node.task.post(function()
	local morse = ".--. .. -. - . .-.   --. .- -... --- .-.     "
	print(("\nMorse code: %q"):format(morse))
	local blinky = M.toblinky(morse)
	print(("Blinky code: %q"):format(blinky))
	if blinky == "- --- --- -   - -   --- -   ---   -   - --- -       --- --- -   - ---   --- - - -   --- --- ---   - --- -           " then
		T.endtest(true, "Correct.")
	else
		T.endtest(false, "It does not work.")
	end
end)

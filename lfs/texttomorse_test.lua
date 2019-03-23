-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local T = require("testutil")
T.callback = ...


-- Convert a pattern
local M = dofile("texttomorse.lua")
node.task.post(function()
	local text = "PINTER GABOR  "
	print(("\nText: %q"):format(text))
	local morse = M.tomorse(text)
	print(("Morse code: %q"):format(morse))
	if morse == ".--. .. -. - . .-.   --. .- -... --- .-.     " then
		T.endtest(true, "Correct.")
	else
		T.endtest(false, "It does not work.")
	end
end)

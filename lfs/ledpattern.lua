-- Advanced LED control

-- Includes
local led = require("led")

-- Module start
local M = {}


-- Pattern
-- It can be either a table, or a string.
-- Table items are passed 'as is' to setstate().
-- String characters ' ', '0' and '_' are translated to 0=OFF,
-- everything else is passed by its numeric code to setstate().
M.pattern = ""


-- Index
local index


-- Timer
local ttmr


-- Interval between items in ms
local interval = 100


-- Set interval between items in ms
-- The default is 100 ms.
function M.setinterval(value)
	interval = value
	if ttmr then
		ttmr:interval(value)
	end
end


-- Rendering function
-- The default is led.setstate, but it can be replaced by anything similar.
M.setstate = led.setstate


-- Called after the end of the pattern period,
-- just after rendering the last item.
M.callback = nil


-- Stop creating pattern
function M.stop()
	if ttmr and ttmr.unregister then
		ttmr:unregister()
		ttmr = nil
		index = nil
	end
	led.off()
end


-- Start creating pattern
function M.start()
	M.stop()
	ttmr = tmr.create()
	index = 0
	ttmr:alarm(interval, tmr.ALARM_AUTO, function()
		-- Counting
		if  #M.pattern <= index then
			index = 1
		else
			index = index+1
		end
		-- Rendering
		if index <= #M.pattern then
			local tp = type(M.pattern)
			if tp == "table" then
				-- Everything is passed 'as is'.
				local code = M.pattern[index]
				M.setstate(code)
			elseif tp == "string" then
				-- ' ', '0' and '_' are translated to 0,
				-- everything else is converted to its numeric code.
				local code = M.pattern:find("^[ 0_]", index) and
					0 or M.pattern:byte(index)
				M.setstate(code)
			end
		end
		-- Callback
		if index == #M.pattern and M.callback then
			node.task.post(M.callback)
		end
	end)
end


-- Start or stop
--  state=true to start, state=false to stop
function M.run(state)
	if state then
		return M.start()
	else
		return M.stop()
	end
end


-- Module end
return M

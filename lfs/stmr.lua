-- Second timer

-- Module start
local M = {}


-- Second timers
-- Key is the second timer, value is its state
local stmrs


-- Timer base
local ttmr


-- Base tick in ms
-- The default is 1s, but it can be changed
local basetick = 1000


-- Base tick can be changed
-- This affects ALL second timers, immediately
function M.setbasetick(tick)
	basetick = tick
	if ttmr then
		ttmr:interval(tick)
	end
end


-- It is running after creating the very first second timer
local function tick()
	-- For each timer
	for t, s in pairs(stmrs) do
		if s.running then
			if s.count==1 then
				-- Fire
				node.task.post(function()
					return s.func(t)
				end)
				-- Next cycle
				s.count = s.interval
				if s.mode==tmr.ALARM_SEMI then
					-- Stop timer
					s.running = false
				elseif s.mode==tmr.ALARM_SINGLE then
					-- Unregister timer
					stmrs[t] = nil
				end
			else
				-- Count
				s.count = s.count-1
			end
		end
	end
end


-- Create a timer
function M.create()
	-- Start base timer when creating the very first second timer
	if not ttmr then
		stmrs = {}
		ttmr = tmr.create()
		ttmr:alarm(basetick, tmr.ALARM_AUTO, tick)
	end

	-- This will be the new second timer
	local T = {}

	function T:register(interval, mode, func)
		-- Register the timer and its state in stmrs
		stmrs[self] = {
			interval=interval, mode=mode, func=func,
			running=false, count=interval
		}
	end

	function T:unregister()
		stmrs[self] = nil
	end

	function T:interval(interval)
		stmrs[self].interval = interval
	end

	function T:start()
		stmrs[self].running = true
	end

	function T:stop()
		stmrs[self] = nil
	end

	function T:alarm(interval, mode, func)
		self:register(interval, mode, func)
		self:start()
	end

	function T:state()
		return stmrs[self].running, stmrs[self].mode
	end

	-- Return the new second timer
	return T
end


-- Explicitly destroy it, if it is no longer needed anywhere
-- to save resources.
function M.destroy()
	-- Kill the timer base
	if ttmr then
		ttmr:unregister()
	end
	-- Delete the timers
	ttmr = nil
	stmrs = nil
end


-- Module end
return M

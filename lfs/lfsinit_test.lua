-- Test

-- If it was called with assert(loadfile("xxx_test.lua"))(callback)
-- then take the callback parameter and use it at the end of the test.
local topcallback = ...
local function endtest(...)
	local ok, msg = ...
	if not ok then
		print(msg)
	end
	if topcallback then
		return node.task.post(function()
			-- Return true on success,
			-- false or nil, and error message on failure.
			topcallback(ok, msg)
		end)
	end
end


-- Check if LFS is present and loaded.
do
	local t, base, mapped, size = node.flashindex()
	if t then
		print(("LFS: t=%d, base=%08X, size=%05X, mapped=%05X"):
			format(t, base, size, mapped))
	else
		print(("LFS: not loaded, base=%08X, mapped=%05X"):
			format(base, mapped))
		return endtest(false, "LFS is not loaded.")
	end
end 


-- Execute lfsinit to make sure that it is active.
-- It can be executed multiple times without any harmful effects.
do
	local ok, msg = pcall(node.flashindex("lfsinit"))
	if not ok then
		return endtest(false, msg)
	end
	ok, msg = pcall(LFS.lfsinit)
	if not ok then
		return endtest(false, msg)
	end
end


-- Check if global LFS is accessible
do
	local t0, lfs_base0, lfs_mapped0, lfs_size0 = node.flashindex()
	local t1 = LFS._time
	local cfg = LFS._config
	if t0 == t1 and 
	   lfs_base0 == cfg.lfs_base and
	   lfs_mapped0 == cfg.lfs_mapped and
	   lfs_size0 == cfg.lfs_size then
		print("LFS._time and LFS._config are correct.")
	else
		return endtest(false, "Something is wrong with LFS access.")
	end
end


-- All tests have ended successfully
return endtest(true)

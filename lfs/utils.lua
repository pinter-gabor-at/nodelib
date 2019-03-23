-- Common utilities

-- Module start
local M = {}


-- List globals
-- Call callback when done.
-- Because it can be a long list,
-- transmitted over a slow serial line,
-- it is split into a chain of tasks.
function M.globals(callback)
	local k

	-- Chain of tasks
	local function printg()
		local v
		k, v = next(_G, k)
		if k then
			-- Print one item
			print(("%-32s :"):format(k), v)
			-- Schedule to print the rest
			return node.task.post(printg)
		elseif callback then
			-- End
			return callback()
		end
	end

	-- Start the chain of tasks
	return printg()
end


-- Strings
-- Call callback when done.
--   r = "RAM" or "ROM"
-- Because it can be a long list,
-- transmitted over a slow serial line,
-- it is split into a chain of tasks.
function M.strings(r, callback)
	local a = debug.getstrings(r or "RAM")
	local i = 0

	-- Chain of tasks
	local function printai()
		if i < #a then
			-- Print one item
			i = i+1
			print(("%q"):format(a[i]))
			-- Schedule to print the rest
			return node.task.post(printai)
		elseif callback then
			-- End
			return callback()
		end
	end

	-- Start the chain of tasks
	return printai()
end


-- Print SPIFFS info
function M.dirinfo()
	local mapped, size = file.fscfg()
	print(("SPIFFS: mapped=%05X, size=%05X"):
		format(mapped, size))
	return mapped, size
end


-- List the contents of the SPIFFS
-- Call callback when done.
-- Because it can be a long list,
-- transmitted over a slow serial line,
-- it is split into a chain of tasks.
function M.dir(callback)
	local list = file.list()
	local n, s = 0, 0
	local k

	-- Chain of tasks
	local function printf()
		local v
		k, v = next(list, k)
		if k then
			-- Print one item
			print(("%-32s : %7d bytes"):format(k, v))
			n = n+1
			s = s+v
			-- Schedule to print the rest
			return node.task.post(printf)
		else
			-- End
			print(string.format("%7d files %18s : %7d bytes", n, "", s))        
			if callback then
				return callback()
			end
		end
	end

	-- Start the chain of tasks
	return printf()
end


-- Print LFS info
function M.lfsdirinfo()
	local t, base, mapped, size = node.flashindex()
	if t then
		print(("LFS: t=%d, base=%08X, size=%05X, mapped=%05X"):
			format(t, base, size, mapped))
	else
		print(("LFS: not loaded, base=%08X, mapped=%05X"):
			format(base, mapped))
	end
	return mapped, size, base
end


-- List the contents of the LFS
-- Call callback when done.
-- Because it can be a long list,
-- transmitted over a slow serial line,
-- it is split into a chain of tasks.
function M.lfsdir(callback)
	local _, _, _, _, modules = node.flashindex()
	local k

	-- Chain of tasks
	local function printf()
		local v
		k, v = next(modules, k)
		if k then
			-- Print one item
			print(v)
			-- Schedule to print the rest
			return node.task.post(printf)
		elseif callback then
			-- End
			return callback()
		end
	end

	-- Start the chain of tasks
	return printf()
end


-- Module end
return M

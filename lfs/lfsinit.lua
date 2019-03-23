-- LFS init

-- This is a template for the LFS equivalent of the SPIFFS init.lua.
--
-- It is a good idea to add such a module to your LFS and do most of the LFS
-- module related initialization in this. This example uses standard Lua features to
-- simplify the LFS API.

-- The usual way to call it is
--   pcall(node.flashindex("lfsinit"))
-- from init.lua.

-- It can be called multiple times.
-- The first call returns true, subsequent calls return false,
-- but have no other side effects.


-- The first section adds a 'LFS' table to _G and uses the __index metamethod to
-- resolve functions in the LFS, so you can execute the main function of module
-- 'fred' by executing LFS.fred(params), etc. It also implements some standard
-- readonly properties:
--
--   LFS._time    The Unix Timestamp when the luac.cross was executed.
-- 	              This can be used as a version identifier.
--
--   LFS._config  This returns a table of useful configuration parameters, hence
-- 	              print (("0x%6x"):format(LFS._config.lfs_base))
--                gives you the parameter to use in the luac.cross -a option.
--
--   LFS._list    This returns a table of the LFS modules, hence
--                print(table.concat(LFS._list,'\n'))
--                gives you a single column listing of all modules in the LFS.
--


-- Global environment
local G = getfenv()

-- Execute this file only once
if G.LFS then return false end

-- Shorthand
local index = node.flashindex

-- Metatable
local lfs_t = {
	__index = function(_, name)
			local fn, base, mapped, size, modules = index(name)
			if not base then
				-- A regular function in LFS
				return fn
			elseif name == '_time' then
				-- Actually it is not a function, but the timestamp of the LFS
				return fn
			elseif name == '_config' then
				-- LFS and SPIFFS configurations as a list
				local fs_mapped, fs_size = file.fscfg()
				return {lfs_base = base, lfs_mapped = mapped, lfs_size = size, 
					fs_mapped = fs_mapped, fs_size = fs_size}
			elseif name == '_list' then
				-- List of modules in LFS
				return modules
			end
		end,

	__newindex = function(_, name, value)
			error("LFS is read only. Invalid write to LFS. " .. name, 2)
		end,
}
G.LFS = setmetatable(lfs_t, lfs_t)


-- The second section adds the LFS to the require searchlist, so that you can
-- require a Lua module 'jean' in the LFS by simply doing require "jean". However
-- note that this is at the search entry following the FS searcher, so if you also
-- have jean.lc or jean.lua in SPIFFS, then this SPIFFS version will get loaded into 
-- RAM instead of using the one in LFS. (Useful, for development).
-- 
-- See docs/en/lfs.md and the 'loaders' array in app/lua/loadlib.c for more details.

-- Loader from LFS
-- Change [3] to [1] to search LFS before SPIFFS.
package.loaders[3] = function(module)
	local fn, base = index(module)
	-- base is nil if the function is in the LFS
	return base and "Module is not in LFS" or fn 
end


-- You can add any other initialization here, for example a couple of the globals
-- are never used, so setting them to nil saves a couple of global entries.

-- disable Lua 5.0 style modules to save RAM 
G.module       = nil
package.seeall = nil


-- Extend loadfile and dofile to search the LFS
-- if the file does not exist in SPIFFS

local lf = loadfile
G.loadfile = function(n)
	-- If the file exists in SPIFFS, load it
	if file.exists(n) then
		return lf(n)
	end
	-- Strip the extension, because LFS does not have extensions
	n = n:match("[^%.]*")
	-- If the file exists in LFS, return it
	local fn, base = index(n)
	-- base is nil if the function is in the LFS
	if not base then
		return fn
	end
	-- Error
	error("File " .. n .. " is not found", 2)
end

local df = dofile
G.dofile = function(n)
	-- If the file exists in SPIFFS, execute it
	if file.exists(n) then
		return df(n)
	end
	-- Strip the extension, because LFS does not have extensions
	n = n:match("[^%.]*")
	-- If the file exists in LFS, execute it
	local fn, base = index(n)
	-- base is nil if the function is in the LFS
	if not base then
		return fn()
	end
	-- Error
	error("File " .. n .. " is not found", 2)
end


-- Success
return true

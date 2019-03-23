-- Test

local M = dofile("utils.lua")
local L = {}

local function lfsdir_test(callback)
	print("\nFiles in LFS:")
	return M.lfsdir()
end

local function dir_test(callback)
	print("\nFiles in SPIFFS:")
	return M.dir(lfsdir_test)
end

local function stringsrom_test()
	print("\nStrings in ROM:")
	return M.strings("ROM", dir_test)
end

local function stringsram_test()
	print("\nStrings in RAM:")
	return M.strings("RAM", stringsrom_test)
end

local function globals_test()
	print("\n\nGlobals:")
	return M.globals(stringsram_test)
end

local function info_test()
	M.dirinfo()
	M.lfsdirinfo()
	return node.task.post(globals_test)
end

-- Run all tests, chained together
return node.task.post(info_test)

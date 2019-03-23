-- Execute a http request

-- Module start
local M = {}


-- Encapsulate http.get()
function M.get(url, headers, callback)
	http.get(url, headers, callback)
end


-- Similar to get, but urls is a list of urls
function M.mget(urls, headers, callback)

	-- Execute callback
	local function docallback(url, status, body, headers)
		if callback then
			node.task.post(function() 
				callback(url, status, body, headers)
			end)
		end
	end

	-- Iterator, defined later
	local iter

	-- Index of the iterator            
	local i = 0

	-- Callback
	local function getcallback(status, body, headers)
		if status == 200 then
			-- Success
			docallback(urls[i], status, body, headers)
		else
			-- Try next
			node.task.post(iter)
		end
	end

	-- Iterator
	iter = function()
		i = i + 1
		if i <= #urls then
			M.get(urls[i], nil, getcallback)
		else
			-- End of the list, and no result
			docallback(nil, -999)
		end
	end

	-- Start evaluating the first
	node.task.post(iter)
end


-- Module end
return M

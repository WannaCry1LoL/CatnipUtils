getgenv = getgenv or function() return _G end
getgenv().deepCopy = function(original: Table)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

getgenv().notif = function(text: string, duration: number, title: string)
    if not title then
        title = "Catnip"
    end
    if not duration then
        duration = 5
    end
    game:GetService('StarterGui'):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

getgenv().randomString = function() -- yes this is from iy
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

type Function = (...any) -> ...any
type Predicate = (...any) -> boolean
type Table = {[any] : any}

local TableLib = {}

TableLib.__index = TableLib

TableLib.__iter = function(t1) return next, t1.data end

TableLib.__add = function(t1, t2) -- union
    local result = {}
    for i,v in pairs(t1.data) do
        result[i] = v
    end
    for i,v in pairs(t2.data) do
        result[i] = v
    end
    return TableLib.new(result)
end

TableLib.__concat = TableLib.__add

TableLib.__eq = function(t1, t2)
    local function DeepEquals(t1, t2--[[, seen]])
        --[[
        seen = seen or {}
        if seen[t1] and seen[t1] == t2 then return true end
        seen[t1] = t2
        ]]  
        for i,v in pairs(t2) do
            if typeof(v) == "table" and t1[i] and typeof(t1[i]) == "table" then
                if not DeepEquals(v, t1[i]) then return false end
            elseif t1[i] ~= v then return false end
        end
        for i,v in pairs(t1) do
            if typeof(v) == "table" and t2[i] and typeof(t2[i]) == "table" then
                if not DeepEquals(v, t2[i]) then return false end
            elseif t2[i] ~= v then return false end
        end
        return true
    end
    return DeepEquals(t1.data, t2.data)
end 

TableLib.__tostring = function(t1)
    local function serializeTable(val, name, skipnewlines, depth)
        skipnewlines = skipnewlines or false
        depth = depth or 0
    
        local tmp = string.rep("\t", depth)
        if name then
            if typeof(name) == "number" then
                tmp = tmp .. "[" .. name .."] = "
            elseif typeof(name) == "string" then
                tmp = tmp .. "[\"" .. name .."\"] = "
            elseif typeof(name) == "boolean" then
                tmp = tmp .. "[" .. (name and "true" or "false") .. "] = "
            end
        end

        if typeof(val) == "table" then
            tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")
    
            for k, v in pairs(val) do
                tmp = tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
            end
    
            tmp = tmp .. string.rep("\t", depth) .. "}"
        elseif typeof(val) == "number" then
            tmp = tmp .. tostring(val)
        elseif typeof(val) == "string" then
            tmp = tmp .. string.format("%q", val)
        elseif typeof(val) == "boolean" then
            tmp = tmp .. (val and "true" or "false")
        elseif typeof(val) == "CFrame" then
            tmp = tmp .. "CFrame.new(" .. tostring(val) .. ")"
        elseif typeof(val) == "Vector3" then
            tmp = tmp .. "Vector3.new(" .. tostring(val) .. ")"
        elseif typeof(val) == "Vector2" then
            tmp = `{tmp}Vector2.new({tostring(val)})`
        elseif typeof(val) == "Instance" then
            tmp = tmp .. val:GetFullName()
        elseif typeof(val) == "EnumItem" then
            tmp = tmp .. val.Name
        elseif typeof(val) == "NumberRange" then
            tmp = `{tmp}NumberRange.new("{val.Min},{val.Max})`
        elseif typeof(val) == "UDim" then
            tmp = `{tmp}UDim.new({tostring(val)})`
        elseif typeof(val) == "UDim2" then
            tmp = `{tmp}UDim2.new(UDim.new({tostring(val.X)}), UDim.new({tostring(val.Y)}))`
        else
            tmp = tmp .. "\"[unhandled datatype (dev was too lazy):" .. typeof(val) .. "]\""
        end
    
        return tmp
    end
    return serializeTable(t1.data)
end

TableLib.__len = function(t1)
    local amount = 0
    for i,v in t1 do
        amount += 1 
    end
    return amount
end

function TableLib.new(data: Table)
    assert(data ~= nil, "Expected table got nil")
    return setmetatable({ data = data }, TableLib)
end

function TableLib:map(func: Function)
    local result = {}
    for i,v in pairs(self.data) do
        result[i] = func(v)
    end
    return TableLib.new(result)
end

function TableLib:foreach(func: Function)
    for i,v in pairs(self.data) do
        func(i, v)
    end
end

function TableLib:toString() : string
    return tostring(self.data)
end

function TableLib:any(func: Predicate): boolean
    for i,v in pairs(self.data) do
        if func(v, i) then return true end
    end
    return false
end

function TableLib:forall(func: Predicate): boolean
    for i,v in pairs(self.data) do
        if not func(v, i) then return false end
    end
    return true
end

function TableLib:filter(func: Predicate)
    local result = {}
    for i,v in self do
        if func(v, i) then
            result[i] = v
        end
    end
    return TableLib.new(result)
end

function TableLib:filterType(arg: string)
    return self:filter(function(v) return typeof(v) == arg end)
end

function TableLib:clone()
    local function deepCopy(original: Table)
        local copy = {}
        for k, v in pairs(original) do
            if typeof(v) == "table" then
                v = deepCopy(v)
            end
            copy[k] = v
        end
        return copy
    end
    return deepCopy(self.data)
end


function TableLib:flatten()
    return error("Not implemented")
end

getgenv().tablelib = TableLib

return TableLib

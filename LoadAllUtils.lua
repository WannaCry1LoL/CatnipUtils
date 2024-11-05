local basePath = "https://raw.githubusercontent.com/WannaCry1LoL/CatnipUtils/main/"
local scriptsToLoad = {
    "GoodSignal/goodsignal.lua",
    "genericBaseFunctions.lua"
}

for i,v in ipairs(scriptsToLoad) do
    loadstring(game:HttpGet(`{basePath}{v}`))()
end

local basePath = "https://raw.githubusercontent.com/WannaCry1LoL/CatnipUtils/refs/heads/main/"
local scriptsToLoad = {
    "GoodSignal/goodsignal",
}

for i,v in ipairs(scriptsToLoad) do
    loadstring(game:HttpGet(`{basepath}{v}.lua`))()
end

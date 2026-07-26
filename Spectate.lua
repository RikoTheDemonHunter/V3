pcall(function()
    local Players = game:GetService("Players")
    local ContentProvider = game:GetService("ContentProvider")
    local LocalPlayer = Players.LocalPlayer

    getgenv().AverySelectedPack = getgenv().AverySelectedPack or nil

    -- Clean up previous UI instance
    local cloneref = cloneref or function(o) return o end
    local CoreGui = cloneref(game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
    local oldGui = CoreGui:FindFirstChild("AveryHubGui")
    if oldGui then oldGui:Destroy() end

    -- R15 Check
    local function checkR15(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid and humanoid.RigType ~= Enum.HumanoidRigType.R15 then 
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rig Error",
                Text = "R15 Rig required for Animation Swapper!",
                Duration = 5
            })
            return false
        end
        return true
    end

    if LocalPlayer.Character and not checkR15(LocalPlayer.Character) then return end

    -- FULL ORIGINAL ANIMATIONS DICTIONARY
    local OriginalAnimations = {
        ["Idle"] = {
            ["2016 Animation (mm2)"] = {"387947158", "387947464"},
            ["(UGC) Oh Really?"] = {"98004748982532", "98004748982532"},
            ["Astronaut"] = {"891621366", "891633237"},
            ["Adidas Community"] = {"122257458498464", "102357151005774"},
            ["Bold"] = {"16738333868", "16738334710"},
            ["(UGC) Slasher"] = {"140051337061095", "140051337061095"},
            ["(UGC) Retro"] = {"80479383912838", "80479383912838"},
            ["(UGC) Magician"] = {"139433213852503", "139433213852503"},
            ["(UGC) John Doe"] = {"72526127498800", "72526127498800"},
            ["(UGC) Noli"] = {"139360856809483", "139360856809483"},
            ["(UGC) Coolkid"] = {"95203125292023", "95203125292023"},
            ["(UGC) Survivor Injured"] = {"73905365652295", "73905365652295"},
            ["(UGC) Retro Zombie"] = {"90806086002292", "90806086002292"},
            ["(UGC) 1x1x1x1"] = {"76780522821306", "76780522821306"},
            ["Borock"] = {"3293641938", "3293642554"},
            ["Bubbly"] = {"910004836", "910009958"},
            ["Cartoony"] = {"742637544", "742638445"},
            ["Confident"] = {"1069977950", "1069987858"},
            ["Catwalk Glam"] = {"133806214992291", "94970088341563"},
            ["Cowboy"] = {"1014390418", "1014398616"},
            ["Drooling Zombie"] = {"3489171152", "3489171152"},
            ["Elder"] = {"10921101664", "10921102574"},
            ["Ghost"] = {"616006778", "616008087"},
            ["Knight"] = {"657595757", "657568135"},
            ["Levitation"] = {"616006778", "616008087"},
            ["Mage"] = {"707742142", "707855907"},
            ["MrToilet"] = {"4417977954", "4417978624"},
            ["Ninja"] = {"656117400", "656118341"},
            ["NFL"] = {"92080889861410", "74451233229259"},
            ["OldSchool"] = {"10921230744", "10921232093"},
            ["Patrol"] = {"1149612882", "1150842221"},
            ["Pirate"] = {"750781874", "750782770"},
            ["Default Retarget"] = {"95884606664820", "95884606664820"},
            ["Very Long"] = {"18307781743", "18307781743"},
            ["Sway"] = {"560832030", "560833564"},
            ["Popstar"] = {"1212900985", "1150842221"},
            ["Princess"] = {"941003647", "941013098"},
            ["R6"] = {"12521158637", "12521162526"},
            ["R15 Reanimated"] = {"4211217646", "4211218409"},
            ["Realistic"] = {"17172918855", "17173014241"},
            ["Robot"] = {"616088211", "616089559"},
            ["Sneaky"] = {"1132473842", "1132477671"},
            ["Sports (Adidas)"] = {"18537376492", "18537371272"},
            ["Soldier"] = {"3972151362", "3972151362"},
            ["Stylish"] = {"616136790", "616138447"},
            ["Stylized Female"] = {"4708191566", "4708192150"},
            ["Superhero"] = {"10921288909", "10921290167"},
            ["Toy"] = {"782841498", "782845736"},
            ["Udzal"] = {"3303162274", "3303162549"},
            ["Vampire"] = {"1083445855", "1083450166"},
            ["Werewolf"] = {"1083195517", "1083214717"},
            ["Wicked (Popular)"] = {"118832222982049", "76049494037641"},
            ["No Boundaries (Walmart)"] = {"18747067405", "18747063918"},
            ["Zombie"] = {"616158929", "616160636"},
            ["(UGC) Zombie"] = {"77672872857991", "77672872857991"},
            ["(UGC) TailWag"] = {"129026910898635", "129026910898635"},
            ["[VOTE] warming up"] = {"83573330053643", "83573330053643"},
            ["cesus"] = {"115879733952840", "115879733952840"},
            ["[VOTE] Float"] = {"110375749767299", "110375749767299"},
            ["UGC Oneleft"] = {"121217497452435", "121217497452435"},
            ["AuraFarming"] = {"138665010911335", "138665010911335"},
            ["[VOTE] Mech Float"] = {"74447366032908", "74447366032908"},
            ["Badware"] = {"140131631438778", "140131631438778"},
            ["Wicked \"Dancing Through Life\""] = {"92849173543269", "132238900951109"},
            ["Unboxed By Amazon"] = {"98281136301627", "138183121662404"}
        },
        ["Walk"] = {
            ["Geto"] = "85811471336028",
            ["Patrol"] = "1151231493",
            ["Drooling Zombie"] = "3489174223",
            ["Adidas Community"] = "122150855457006",
            ["Levitation"] = "616013216",
            ["Catwalk Glam"] = "109168724482748",
            ["Knight"] = "10921127095",
            ["Pirate"] = "750785693",
            ["Bold"] = "16738340646",
            ["Sports (Adidas)"] = "18537392113",
            ["Zombie"] = "616168032",
            ["Astronaut"] = "891667138",
            ["Cartoony"] = "742640026",
            ["Ninja"] = "656121766",
            ["Confident"] = "1070017263",
            ["Wicked \"Dancing Through Life\""] = "73718308412641",
            ["Unboxed By Amazon"] = "90478085024465",
            ["Gojo"] = "95643163365384",
            ["R15 Reanimated"] = "4211223236",
            ["Ghost"] = "616013216",
            ["2016 Animation (mm2)"] = "387947975",
            ["(UGC) Zombie"] = "113603435314095",
            ["No Boundaries (Walmart)"] = "18747074203",
            ["Rthro"] = "10921269718",
            ["Werewolf"] = "1083178339",
            ["Wicked (Popular)"] = "92072849924640",
            ["Vampire"] = "1083473930",
            ["Popstar"] = "1212980338",
            ["Mage"] = "707897309",
            ["(UGC) Smooth"] = "76630051272791",
            ["R6"] = "12518152696",
            ["NFL"] = "110358958299415",
            ["Bubbly"] = "910034870",
            ["(UGC) Retro"] = "107806791584829",
            ["(UGC) Retro Zombie"] = "140703855480494",
            ["OldSchool"] = "10921244891",
            ["Elder"] = "10921111375",
            ["Stylish"] = "616146177",
            ["Stylized Female"] = "4708193840",
            ["Robot"] = "616095330",
            ["Sneaky"] = "1132510133",
            ["Superhero"] = "10921298616",
            ["Udzal"] = "3303162967",
            ["Toy"] = "782843345",
            ["Default Retarget"] = "115825677624788",
            ["Princess"] = "941028902",
            ["Cowboy"] = "1014421541"
        },
        ["Run"] = {
            ["Robot"] = "10921250460",
            ["Patrol"] = "1150967949",
            ["Drooling Zombie"] = "3489173414",
            ["Adidas Community"] = "82598234841035",
            ["Heavy Run (Udzal / Borock)"] = "3236836670",
            ["Catwalk Glam"] = "81024476153754",
            ["Knight"] = "10921121197",
            ["Pirate"] = "750783738",
            ["Bold"] = "16738337225",
            ["Sports (Adidas)"] = "18537384940",
            ["Zombie"] = "616163682",
            ["Astronaut"] = "10921039308",
            ["Cartoony"] = "10921076136",
            ["Ninja"] = "656118852",
            ["(UGC) Dog"] = "130072963359721",
            ["Wicked \"Dancing Through Life\""] = "135515454877967",
            ["Unboxed By Amazon"] = "134824450619865",
            ["[UGC] Flipping"] = "124427738251511",
            ["Sneaky"] = "1132494274",
            ["R6"] = "12518152696",
            ["[VOTE] Aura"] = "120142877225965",
            ["Popstar"] = "1212980348",
            ["Wicked (Popular)"] = "72301599441680",
            ["[UGC] chibi"] = "85887415033585",
            ["R15 Reanimated"] = "4211220381",
            ["Mage"] = "10921148209",
            ["Ghost"] = "616013216",
            ["Rthro"] = "10921261968",
            ["Confident"] = "1070001516",
            ["Stylized Female"] = "4708192705",
            ["No Boundaries (Walmart)"] = "18747070484",
            ["Elder"] = "10921104374",
            ["Werewolf"] = "10921336997",
            ["[UGC] Girly"] = "128578785610052",
            ["Stylish"] = "10921276116",
            ["(UGC) Pride"] = "116462200642360",
            ["NFL"] = "117333533048078",
            ["(UGC) Soccer"] = "116881956670910",
            ["MrToilet"] = "4417979645",
            ["[VOTE] Float"] = "71267457613791",
            ["Levitation"] = "616010382",
            ["(UGC) Retro"] = "107806791584829",
            ["(UGC) Retro Zombie"] = "140703855480494",
            ["OldSchool"] = "10921240218",
            ["Vampire"] = "10921320299",
            ["furry"] = "102269417125238",
            ["Bubbly"] = "10921057244",
            ["fake wicked"] = "138992096476836",
            ["2016 Animation (mm2)"] = "387947975",
            ["[UGC] ball"] = "132499588684957",
            ["Superhero"] = "10921291831",
            ["Toy"] = "10921306285",
            ["Default Retarget"] = "102294264237491",
            ["Princess"] = "941015281",
            ["Cowboy"] = "1014401683"
        },
        ["Jump"] = {
            ["Robot"] = "616090535",
            ["Patrol"] = "1148811837",
            ["Adidas Community"] = "75290611992385",
            ["Levitation"] = "616008936",
            ["Catwalk Glam"] = "116936326516985",
            ["Knight"] = "910016857",
            ["Pirate"] = "750782230",
            ["Bold"] = "16738336650",
            ["Sports (Adidas)"] = "18537380791",
            ["Zombie"] = "616161997",
            ["Astronaut"] = "891627522",
            ["Cartoony"] = "742637942",
            ["Ninja"] = "656117878",
            ["Confident"] = "1069984524",
            ["Wicked \"Dancing Through Life\""] = "78508480717326",
            ["Unboxed By Amazon"] = "121454505477205",
            ["R6"] = "12520880485",
            ["R15 Reanimated"] = "4211219390",
            ["Ghost"] = "616008936",
            ["Rthro"] = "10921263860",
            ["No Boundaries (Walmart)"] = "18747069148",
            ["Werewolf"] = "1083218792",
            ["Cowboy"] = "1014394726",
            ["UGC"] = "91788124131212",
            ["[VOTE] Animal"] = "131203832825082",
            ["Popstar"] = "1212954642",
            ["Mage"] = "10921149743",
            ["Sneaky"] = "1132489853",
            ["Superhero"] = "10921294559",
            ["Elder"] = "10921107367",
            ["(UGC) Retro"] = "139390570947836",
            ["NFL"] = "119846112151352",
            ["OldSchool"] = "10921242013",
            ["Stylized Female"] = "4708188025",
            ["Stylish"] = "616139451",
            ["Bubbly"] = "910016857",
            ["[VOTE] Float"] = "75611679208549",
            ["[VOTE] Aura"] = "93382302369459",
            ["Vampire"] = "1083455352",
            ["Wicked (Popular)"] = "104325245285198",
            ["Toy"] = "10921308158",
            ["Default Retarget"] = "117150377950987",
            ["Princess"] = "941008832",
            ["[UGC] happy"] = "72388373557525"
        },
        ["Fall"] = {
            ["Robot"] = "616087089",
            ["Patrol"] = "1148863382",
            ["Adidas Community"] = "98600215928904",
            ["Levitation"] = "616005863",
            ["Catwalk Glam"] = "92294537340807",
            ["Knight"] = "10921122579",
            ["Pirate"] = "750780242",
            ["Bold"] = "16738333171",
            ["Sports (Adidas)"] = "18537367238",
            ["Zombie"] = "616157476",
            ["Astronaut"] = "891617961",
            ["Cartoony"] = "742637151",
            ["Ninja"] = "656115606",
            ["Confident"] = "1069973677",
            ["Wicked \"Dancing Through Life\""] = "78147885297412",
            ["Unboxed By Amazon"] = "94788218468396",
            ["R6"] = "12520972571",
            ["[UGC] skydiving"] = "102674302534126",
            ["R15 Reanimated"] = "4211216152",
            ["Rthro"] = "10921262864",
            ["No Boundaries (Walmart)"] = "18747062535",
            ["Werewolf"] = "1083189019",
            ["[VOTE] TPose"] = "139027266704971",
            ["Mage"] = "707829716",
            ["[VOTE] Animal"] = "77069224396280",
            ["Wicked (Popular)"] = "121152442762481",
            ["Popstar"] = "1212900995",
            ["NFL"] = "129773241321032",
            ["OldSchool"] = "10921241244",
            ["Sneaky"] = "1132469004",
            ["Elder"] = "10921105765",
            ["Bubbly"] = "910001910",
            ["Stylish"] = "616134815",
            ["Stylized Female"] = "4708186162",
            ["Vampire"] = "1083443587",
            ["Superhero"] = "10921293373",
            ["Toy"] = "782846423",
            ["Default Retarget"] = "110205622518029",
            ["Princess"] = "941000007",
            ["Cowboy"] = "1014384571"
        },
        ["Climb"] = {
            ["Robot"] = "616086039",
            ["Patrol"] = "1148811837",
            ["Adidas Community"] = "88763136693023",
            ["Levitation"] = "10921132092",
            ["Catwalk Glam"] = "119377220967554",
            ["Knight"] = "10921125160",
            ["[VOTE] Animal"] = "124810859712282",
            ["Bold"] = "16738332169",
            ["Sports (Adidas)"] = "18537363391",
            ["Zombie"] = "616156119",
            ["Astronaut"] = "10921032124",
            ["Cartoony"] = "742636889",
            ["Ninja"] = "656114359",
            ["Confident"] = "1069946257",
            ["Wicked \"Dancing Through Life\""] = "129447497744818",
            ["Unboxed By Amazon"] = "121145883950231",
            ["R6"] = "12520982150",
            ["Ghost"] = "616003713",
            ["Rthro"] = "10921257536",
            ["CowBoy"] = "1014380606",
            ["No Boundaries (Walmart)"] = "18747060903",
            ["Mage"] = "707826056",
            ["[VOTE] sticky"] = "77520617871799",
            ["Reanimated R15"] = "4211214992",
            ["Popstar"] = "1213044953",
            ["(UGC) Retro"] = "121075390792786",
            ["NFL"] = "134630013742019",
            ["OldSchool"] = "10921229866",
            ["Sneaky"] = "1132461372",
            ["Elder"] = "845392038",
            ["Stylized Female"] = "4708184253",
            ["Stylish"] = "10921271391",
            ["SuperHero"] = "10921286911",
            ["WereWolf"] = "10921329322",
            ["Vampire"] = "1083439238",
            ["Toy"] = "10921300839",
            ["Wicked (Popular)"] = "131326830509784",
            ["Princess"] = "940996062",
            ["[VOTE] Rope"] = "134977367563514"
        }
    }

    local function FormatAssetId(id)
        if not id or id == "0" then return "" end
        return id:find("rbxassetid://") and id or ("rbxassetid://" .. id)
    end

    local function ApplyAnimationPack(char, packName)
        if not char or not packName then return end
        local humanoid = char:WaitForChild("Humanoid", 5)
        local animateScript = char:WaitForChild("Animate", 5)
        if not humanoid or not animateScript then return end

        local function getPackAsset(category, name)
            if OriginalAnimations[category] and OriginalAnimations[category][name] then
                return OriginalAnimations[category][name]
            end
            return nil
        end

        local idleAsset = getPackAsset("Idle", packName)
        local walkAsset = getPackAsset("Walk", packName)
        local runAsset = getPackAsset("Run", packName)
        local jumpAsset = getPackAsset("Jump", packName)
        local fallAsset = getPackAsset("Fall", packName)
        local climbAsset = getPackAsset("Climb", packName)

        local function setAnim(folderName, animName, rawId)
            if not rawId then return end
            local folder = animateScript:FindFirstChild(folderName)
            if folder then
                local anim = folder:FindFirstChild(animName) or folder:FindFirstChildOfClass("Animation")
                if anim then
                    anim.AnimationId = FormatAssetId(rawId)
                end
            end
        end

        if idleAsset then
            if type(idleAsset) == "table" then
                setAnim("idle", "Animation1", idleAsset[1])
                setAnim("idle", "Animation2", idleAsset[2] or idleAsset[1])
            else
                setAnim("idle", "Animation1", idleAsset)
            end
        end

        if walkAsset then setAnim("walk", "WalkAnim", walkAsset) end
        if runAsset then setAnim("run", "RunAnim", runAsset) end
        if jumpAsset then setAnim("jump", "JumpAnim", jumpAsset) end
        if fallAsset then setAnim("fall", "FallAnim", fallAsset) end
        if climbAsset then setAnim("climb", "ClimbAnim", climbAsset) end

        -- Preload to bypass sanitization asset download errors
        task.spawn(function()
            local toPreload = {}
            for _, category in pairs({"Idle", "Walk", "Run", "Jump", "Fall", "Climb"}) do
                local asset = getPackAsset(category, packName)
                if type(asset) == "table" then
                    for _, id in ipairs(asset) do
                        local a = Instance.new("Animation")
                        a.AnimationId = FormatAssetId(id)
                        table.insert(toPreload, a)
                    end
                elseif asset then
                    local a = Instance.new("Animation")
                    a.AnimationId = FormatAssetId(asset)
                    table.insert(toPreload, a)
                end
            end
            pcall(function() ContentProvider:PreloadAsync(toPreload) end)
        end)

        -- Restart default Animate script
        animateScript.Disabled = true
        task.wait(0.05)
        animateScript.Disabled = false

        -- Clear current tracks
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
        end
    end

    local function setupCharacter(char)
        if getgenv().AverySelectedPack and checkR15(char) then
            task.wait(0.3)
            ApplyAnimationPack(char, getgenv().AverySelectedPack)
        end
    end

    if LocalPlayer.Character then
        setupCharacter(LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(setupCharacter)

    -- UI CREATION
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AveryHubGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "AveryToggle"
    toggleBtn.Size = UDim2.new(0, 110, 0, 38)
    toggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    toggleBtn.Text = "AVERY HUB"
    toggleBtn.TextColor3 = Color3.fromRGB(0, 230, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 13
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = screenGui

    local toggleCorner = Instance.new("UICorner", toggleBtn)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = Color3.fromRGB(0, 180, 220)
    toggleStroke.Thickness = 1.5

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.85, 0, 0.65, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local aspectConstraint = Instance.new("UIAspectRatioConstraint", mainFrame)
    aspectConstraint.AspectRatio = 1.3
    aspectConstraint.AspectType = Enum.AspectType.FitWithinMaxSize

    local frameCorner = Instance.new("UICorner", mainFrame)
    frameCorner.CornerRadius = UDim.new(0, 12)

    local frameStroke = Instance.new("UIStroke", mainFrame)
    frameStroke.Color = Color3.fromRGB(45, 45, 55)
    frameStroke.Thickness = 1.5

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0.15, 0)
    header.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    header.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.04, 0, 0, 0)
    titleLabel.Text = "AVERY ANIMATION HUB"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0.12, 0, 0.6, 0)
    closeBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextScaled = true
    closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeBtn.BorderSizePixel = 0

    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 6)

    local isOpen = true
    local function setMenuVisible(state)
        isOpen = state
        if state then
            mainFrame.Visible = true
            mainFrame:TweenSize(UDim2.new(0.85, 0, 0.65, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.25, true)
        else
            mainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.2, true, function()
                mainFrame.Visible = false
            end)
        end
    end

    closeBtn.MouseButton1Click:Connect(function() setMenuVisible(false) end)
    toggleBtn.MouseButton1Click:Connect(function() setMenuVisible(not isOpen) end)

    local searchBar = Instance.new("TextBox", mainFrame)
    searchBar.PlaceholderText = "🔍 Search animation packs..."
    searchBar.Font = Enum.Font.Gotham
    searchBar.TextScaled = true
    searchBar.TextColor3 = Color3.fromRGB(240, 240, 240)
    searchBar.PlaceholderColor3 = Color3.fromRGB(130, 130, 140)
    searchBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    searchBar.BorderSizePixel = 0
    searchBar.Size = UDim2.new(0.92, 0, 0.11, 0)
    searchBar.Position = UDim2.new(0.04, 0, 0.18, 0)

    local searchCorner = Instance.new("UICorner", searchBar)
    searchCorner.CornerRadius = UDim.new(0, 6)

    local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
    scrollFrame.Size = UDim2.new(0.92, 0, 0.65, 0)
    scrollFrame.Position = UDim2.new(0.04, 0, 0.31, 0)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 220)

    local scrollLayout = Instance.new("UIListLayout", scrollFrame)
    scrollLayout.SortOrder = Enum.SortOrder.Name
    scrollLayout.Padding = UDim.new(0, 6)

    local function updateCanvas()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
    end
    scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    -- Extract unique pack names across categories
    local packNamesList = {}
    local addedPacks = {}

    for _, category in pairs(OriginalAnimations) do
        for packName, _ in pairs(category) do
            if not addedPacks[packName] then
                addedPacks[packName] = true
                table.insert(packNamesList, packName)
            end
        end
    end

    table.sort(packNamesList)

    local buttons = {}
    for _, packName in ipairs(packNamesList) do
        local btn = Instance.new("TextButton")
        btn.Name = packName
        btn.Text = packName
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(220, 220, 225)
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        btn.Size = UDim2.new(0.98, 0, 0, 36)
        btn.BorderSizePixel = 0
        btn.Parent = scrollFrame

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        if getgenv().AverySelectedPack == packName then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 190)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        btn.MouseButton1Click:Connect(function()
            getgenv().AverySelectedPack = packName
            ApplyAnimationPack(LocalPlayer.Character, packName)

            for _, b in ipairs(buttons) do
                b.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
                b.TextColor3 = Color3.fromRGB(220, 220, 225)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 190)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(buttons, btn)
    end

    task.defer(updateCanvas)

    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local filter = searchBar.Text:lower()
        for _, btn in ipairs(buttons) do
            btn.Visible = (filter == "" or btn.Name:lower():find(filter, 1, true) ~= nil)
        end
    end)
end)

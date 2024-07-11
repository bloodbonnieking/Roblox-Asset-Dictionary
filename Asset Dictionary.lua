--!native

local ModuleDictionary = {}
ModuleDictionary.Dictionaries = {
	GeneralDictionary = {};
	DecalDictionary = {};
	TextureDictionary = {};
	SoundDictionary = {};
	MeshDictionary = {};
	AnimationDictionary = {};
	VideoDictionary = {};
	ImageLabelDictionary = {};
	ImageButtonDictionary = {};
	ShirtDictionary = {};
	PantsDictionary = {};
}
local Dictionaries = ModuleDictionary.Dictionaries

--//main functions

local function AddToTable(Target, Print)
	local Start = os.clock()
	for index = 1, #Target do
		local Cases = {
			["Decal"] = function ()
				table.insert(Dictionaries.DecalDictionary, Target[index].Texture)
				table.insert(Dictionaries.GeneralDictionary, Target[index].Texture)
			end,
			["Texture"] = function ()
				table.insert(Dictionaries.TextureDictionary, Target[index].Texture)
				table.insert(Dictionaries.GeneralDictionary, Target[index].Texture)
			end,
			["Sound"] = function ()
				table.insert(Dictionaries.TextureDictionary, Target[index].SoundId)
				table.insert(Dictionaries.GeneralDictionary, Target[index].SoundId)
			end,
			["Mesh"] = function ()
				table.insert(Dictionaries.MeshDictionary, Target[index].MeshId)
				table.insert(Dictionaries.GeneralDictionary, Target[index].MeshId)
			end,
			["Animation"] = function ()
				table.insert(Dictionaries.AnimationDictionary, Target[index].AnimationId)
				table.insert(Dictionaries.GeneralDictionary, Target[index].AnimationId)
			end,
			["VideoFrame"] = function ()
				table.insert(Dictionaries.VideoDictionary, Target[index].Video)
				table.insert(Dictionaries.GeneralDictionary, Target[index].Video)
			end,
			["ImageLabel"] = function ()
				table.insert(Dictionaries.ImageLabelDictionary, Target[index].Image)
				table.insert(Dictionaries.GeneralDictionary, Target[index].Image)
			end,
			["ImageButton"] = function ()
				table.insert(Dictionaries.ImageButtonDictionary, Target[index].Image)
				table.insert(Dictionaries.GeneralDictionary, Target[index].Image)
			end,
			["Shirt"] = function ()
				table.insert(Dictionaries.ShirtDictionary, Target[index].ShirtTemplate)
				table.insert(Dictionaries.GeneralDictionary, Target[index].ShirtTemplate)
			end,
			["Pants"] = function ()
				table.insert(Dictionaries.PantsDictionary, Target[index].PantsTemplate)
				table.insert(Dictionaries.GeneralDictionary, Target[index].PantsTemplate)
			end,
		}
		if Print then
			print(`Name: {Target[index]} ClassName: {Target[index].ClassName}`)
		end
		local success, err = pcall(function()
			Cases[Target[index].ClassName]()
		end)
		if not success and Print then
			warn("Instance is not supported. Expected a downloadable or supported asset, got "..tostring(Target[index].ClassName))
		end
	end
	local End = os.clock()
	if Print then
		print(`For loop took: {End - Start}`)
	end
end



function ModuleDictionary:GetDictionary(Target: Instance, Descendants: boolean?, ClearTables: boolean?, Sort: boolean?, Reverse: boolean?, DeleteTarget: boolean?, Print: boolean?)

	local StartTime = os.clock()
	if typeof(Target) ~= "Instance" then error(`GetDictionary expects Target to be an instance, got {tostring(Target)}`) end	
	if typeof(Descendants) ~= "boolean" then Descendants = false end
	if typeof(ClearTables) ~= "boolean" then ClearTables = true end
	if typeof(DeleteTarget) ~= "boolean" then DeleteTarget = false end
	if typeof(Sort) ~= "boolean" then Sort = true end
	if typeof(Reverse) ~= "boolean" then Reverse = true end
	if typeof(Print) ~= "boolean" then Print = false end

	if ClearTables == true then
		for _, tables in pairs(Dictionaries) do
			table.clear(tables)
		end	
	end

	if Descendants == false then
		AddToTable(Target:GetChildren(), Print)
	elseif Descendants == true then
		AddToTable(Target:GetDescendants(), Print)
	end


	local function ReverseTable(ID1, ID2)
		pcall(function()
			--print(ID1, ID2)
			return ID1 > ID2
		end)
	end


	if Reverse == false and Sort == true then
		for _, tables in pairs(Dictionaries) do
			table.sort(tables)
		end
	elseif Reverse == true and Sort == true then
		for _, tables in pairs(Dictionaries) do
			print(tables)
			table.sort(tables, ReverseTable)
		end
	end


	if DeleteTarget == true then
		Target:Destroy()
	end

	if Print == true then
		print("General:", Dictionaries.GeneralDictionary)
		print("Decals:", Dictionaries.DecalDictionary)
		print("Textures:", Dictionaries.TextureDictionary)
		print("Sounds:", Dictionaries. SoundDictionary)
		print("Meshes:", Dictionaries.MeshDictionary)
		print("Animations:", Dictionaries.AnimationDictionary)
		print("Videos:", Dictionaries.VideoDictionary)
		print("Image Labels:", Dictionaries.ImageLabelDictionary)
		print("Image Buttons:", Dictionaries.ImageButtonDictionary)
		print("Shirts:", Dictionaries.ShirtDictionary)
		print("Pants:", Dictionaries.PantsDictionary)
		local EndTime = os.clock()
		print(`Took: {EndTime - StartTime}`)
	end
end

--//memory freeing functions

function ModuleDictionary:ClearTable(Table: string)
	if typeof(Table) == "string" then
		local success, err = pcall(function()
			print(Table)
			if Table:find("Dictionary") then
				table.clear(Dictionaries[Table])
			else
				table.clear(Dictionaries[Table.. "Dictionary"])
			end
		end)
		if not success then
			error("ClearTable expects the string to be a supported asset, got "..Table, 2)
		end
	end
end

function ModuleDictionary:ClearAllTables() --//no arguments needed, and will only clear asset dictionary tables.
	for _, tables in pairs (Dictionaries) do
		table.clear(tables)
	end
end

task.spawn(function()
	while task.wait(1) do
	print(Dictionaries)
	end
end)

return ModuleDictionary
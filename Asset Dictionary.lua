--!native

local ModuleDictionary = {}
local TemplateDictionaries = {
	GeneralDictionary = {};
	DecalDictionary = {};
	TextureDictionary = {};
	SoundDictionary = {};
	MeshPartDictionary = {};
	SpecialMeshDictionary = {};
	AnimationDictionary = {};
	VideoFrameDictionary = {};
	ImageLabelDictionary = {};
	ImageButtonDictionary = {};
	ShirtDictionary = {};
	PantsDictionary = {};
	ParticleEmitterDictionary = {}
}

local function AddToTable(Dictionary, TargetArray, Warn)
	for _, Asset: Instance in pairs(TargetArray) do
		local AssetDictionary = Dictionary[`{Asset.ClassName}Dictionary`]

		if not AssetDictionary then

			if Warn then
				warn(`Invalid Instance type. Expected Asset, got {Asset:GetFullName()}: {Asset.ClassName}`)
			end

			continue
		end
		
		table.insert(AssetDictionary, Asset)
		table.insert(Dictionary.GeneralDictionary, Asset)
	end
end


function ModuleDictionary:GetAssets(Target: Instance, Recursive: boolean?, DebugWarn: boolean?)
	local TargetArray

	assert(typeof(Target) == "Instance", `GetDictionary expects Target to be an instance, got {tostring(Target)}`)	
	if typeof(Recursive) ~= "boolean" then Recursive = false end
	if typeof(DebugWarn) ~= "boolean" then DebugWarn = false end
	
	local Dictionaries = table.clone(TemplateDictionaries)

	if not Recursive then
		TargetArray = Target:GetChildren()
	elseif Recursive then
		TargetArray = Target:GetDescendants()
	end

	AddToTable(Dictionaries, TargetArray, DebugWarn)
	return Dictionaries
end

return ModuleDictionary

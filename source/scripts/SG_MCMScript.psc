Scriptname SG_MCMScript extends MCM_ConfigBase

GlobalVariable Property SG_MinChanceGlobal Auto

int Function GetVersion()

	Return 2
	
EndFunction

Event OnConfigInit()
	LoadSettings()
EndEvent

Event OnGameReload()
	Parent.OnGameReload()
	LoadSettings()
EndEvent

Event OnVersionUpdate(int a_Version)
	
	If CurrentVersion != 0 && CurrentVersion < 2 && a_version >= 2
		SetModSettingInt("iWord:MinChance", SG_MinChanceGlobal.GetValueInt())
	endIf

EndEvent

Event OnSettingChange(string a_ID)

	int Value = GetModSettingInt(a_id)
	If a_ID == "iWord:MinChance"
		SG_MinChanceGlobal.SetValueInt(Value)
	endIf

EndEvent 

Event OnConfigClose()

	SG_MinChanceGlobal.SetValueInt(GetModSettingInt("iWord:MinChance"))

EndEvent

Function LoadSettings()
	
	SG_MinChanceGlobal.SetValueInt(GetModSettingInt("iWord:MinChance"))
	
EndFunction 
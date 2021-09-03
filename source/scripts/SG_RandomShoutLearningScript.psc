Scriptname SG_RandomShoutLearningScript extends ReferenceAlias

FormList Property SG_ShoutsListPrefilled Auto
FormList Property SG_ShoutsList Auto
FormList Property SG_ShoutsWWGlobalList Auto

GlobalVariable Property SG_MinChanceGlobal Auto

Shout Property FireBreath Auto
Shout Property WhirlwindSprint Auto

WordOfPower Property WordFus Auto

Event OnInit()

	RegisterForTrackedStatsEvent()
	
	Int N = SG_ShoutsListPrefilled.GetSize()
	While N > 0
    N -= 1
    Form F = SG_ShoutsListPrefilled.GetAt(N)
    SG_ShoutsList.AddForm(F)
		If Game.IsPluginInstalled("ForcefulTongue.esp") == 1.0
		Shout PhantomForm = Game.GetFormFromFile(0xC26, "Forceful Tongue.esp") as Shout
		SG_ShoutsList.AddForm(PhantomForm)
		elseIf Game.IsPluginInstalled("Wyrmstooth.esp") == 1.0
		Shout PhantomFormWyrm = Game.GetFormFromFile(0x30C92F, "Wyrmstooth.esp") as Shout
		SG_ShoutsList.AddForm(PhantomFormWyrm)
		endIf
	endWhile
	
EndEvent

Event OnPlayerLoadGame()

    RegisterForTrackedStatsEvent()
	
	If Game.IsPluginInstalled("ForcefulTongue.esp") == 1.0
	Shout PhantomForm = Game.GetFormFromFile(0xC26, "Forceful Tongue.esp") as Shout
		If SG_ShoutsList.HasForm(PhantomForm)
			Return
		else 
			SG_ShoutsList.AddForm(PhantomForm)
		endIf
	elseIf Game.IsPluginInstalled("Wyrmstooth.esp") == 1.0
	Shout PhantomFormWyrm = Game.GetFormFromFile(0x30C92F, "Wyrmstooth.esp") as Shout
		If SG_ShoutsList.HasForm(PhantomFormWyrm)
			Return
		else
			SG_ShoutsList.AddForm(PhantomFormWyrm)
		endIf
	endIf

EndEvent

Event OnTrackedStatsEvent(String asStatFilter, Int aiStatValue)

	If Game.IsWordUnlocked(WordFus)
		If (asStatFilter == "Dragon Souls Collected") && Utility.RandomInt(1,100) <= (SG_MinChanceGlobal.GetValueInt())
		Int ListLength = SG_ShoutsList.GetSize()
		Int RandIndex = Utility.RandomInt(0, ListLength - 1)
		Shout S = SG_ShoutsList.GetAt(RandIndex) as Shout
		WordOfPower One = S.GetNthWordOfPower(0)
		WordOfPower Two = S.GetNthWordOfPower(1)
		WordOfPower Three = S.GetNthWordOfPower(2)
		Int ShoutsIndex = SG_ShoutsListPrefilled.Find(S)
		GlobalVariable ShoutsGlobal = SG_ShoutsWWGlobalList.GetAt(ShoutsIndex) as GlobalVariable
			ShoutsGlobal.Value += 1
		If (Three.PlayerKnows())
			SG_ShoutsList.RemoveAddedForm(S)
		elseIf (Two.PlayerKnows())
			LearnWord(Three)
			SG_ShoutsList.RemoveAddedForm(S)
		elseIf (One.PlayerKnows())
			LearnWord(Two)
		If (S == FireBreath)
			SG_ShoutsList.RemoveAddedForm(FireBreath) ;Paarthurnax teaches you a Word
		elseIf (S == WhirlwindSprint)
			SG_ShoutsList.RemoveAddedForm(WhirlwindSprint) ;Greybeards teach you a Word
		endIf
		else
			LearnWord(One)
		endIf
		endIf
	endIf
	
EndEvent

Function LearnWord(WordOfPower W)

	Game.TeachWord(W)
	
EndFunction 
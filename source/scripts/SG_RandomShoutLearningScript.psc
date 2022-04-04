Scriptname SG_RandomShoutLearningScript extends ReferenceAlias

FormList Property SG_ShoutsListPrefilled Auto
FormList Property SG_ShoutsList Auto
FormList Property SG_ShoutsWWGlobalList Auto

GlobalVariable Property SG_MinChanceGlobal Auto
GlobalVariable Property WWAnimalAllegiance Auto
GlobalVariable Property WWFireBreath Auto
GlobalVariable Property WWPhantomForm Auto

Quest Property MQ204 Auto
Quest Property dunAngarvundeQST Auto

Shout Property AnimalAllegiance Auto
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
		SG_ShoutsListPrefilled.AddForm(PhantomForm)
		SG_ShoutsList.AddForm(PhantomForm)
		SG_ShoutsWWGlobalList.AddForm(WWPhantomForm)
		elseIf Game.IsPluginInstalled("Wyrmstooth.esp") == 1.0
		Shout PhantomFormWyrm = Game.GetFormFromFile(0x30C92F, "Wyrmstooth.esp") as Shout
		SG_ShoutsListPrefilled.AddForm(PhantomFormWyrm)
		SG_ShoutsList.AddForm(PhantomFormWyrm)
		SG_ShoutsWWGlobalList.AddForm(WWPhantomForm)		
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
			SG_ShoutsListPrefilled.AddForm(PhantomForm)
			SG_ShoutsList.AddForm(PhantomForm)
			SG_ShoutsWWGlobalList.AddForm(WWPhantomForm)
		endIf
	elseIf Game.IsPluginInstalled("Wyrmstooth.esp") == 1.0
	Shout PhantomFormWyrm = Game.GetFormFromFile(0x30C92F, "Wyrmstooth.esp") as Shout
		If SG_ShoutsList.HasForm(PhantomFormWyrm)
			Return
		else
			SG_ShoutsListPrefilled.AddForm(PhantomFormWyrm)
			SG_ShoutsList.AddForm(PhantomFormWyrm)
			SG_ShoutsWWGlobalList.AddForm(WWPhantomForm)
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
				else
					LearnWord(One)
				endIf

				Int Q1 = 0
				While Q1 < 1
					If MQ204.IsCompleted() != 1
						Return
					else
						SG_ShoutsListPrefilled.AddForm(FireBreath)
						SG_ShoutsList.AddForm(FireBreath)
						SG_ShoutsWWGlobalList.AddForm(WWFireBreath)
						Q1 += 1
					endIf
				endWhile

				Int Q2 = 0
				While Q2 < 1 
					If dunAngarvundeQST.IsCompleted() != 1
						Return
					else
						SG_ShoutsListPrefilled.AddForm(AnimalAllegiance)
						SG_ShoutsList.AddForm(AnimalAllegiance)
						SG_ShoutsWWGlobalList.AddForm(WWAnimalAllegiance)
						Q2 += 1
					endIf
				endWhile		
			
			If (S == WhirlwindSprint)
				SG_ShoutsList.RemoveAddedForm(WhirlwindSprint) ;Greybeards teach you a Word
			endIf
		endIf
	endIf
	
EndEvent

Function LearnWord(WordOfPower W)

	Game.TeachWord(W)
	
EndFunction 
Scriptname zzzmoautilscript

import StringUtil

Int Function iMin(Int a,Int b) Global
{find minimum of two ints.}
	If a <= b
		Return a
	EndIf
	Return b
EndFunction

Float Function fMin(Float a,Float b) Global
{find minimum of two floats.}
	If a <= b
		Return a
	EndIf
	Return b
EndFunction

Float Function fMax(Float a,Float b) Global
{find maximum of two floats.}
	If a >= b
		Return a
	EndIf
	Return b
EndFunction

Int Function iMax(Int a,Int b) Global
{find maximum of two ints.}
	If a >= b
		Return a
	EndIf
	Return b
EndFunction

Int Function iGetRandomWithExclusion( Int iFrom, Int iTo, Int iExclude) Global
{Generates a random integer between iFrom and iTo (inclusive), excluding one value}
	If (iExclude == iFrom) && (iExclude == iTo)
		Return iExclude
	EndIf
	If ( iExclude > iTo ) || ( iExclude < iFrom )
		Return Utility.RandomInt(iFrom, iTo)
	EndIf
	Int iRandom = Utility.RandomInt(iFrom, iTo - 1)
	If iRandom >= iExclude
		iRandom += 1
	EndIf
	Return iRandom
EndFunction

Int Function iGetRandomWithExclusionIntArray( Int iFrom, Int iTo, Int[] iExcludes) Global
{Generates a random integer between iFrom and iTo (inclusive), excluding values in an array}
	If iFrom == iTo
		Return iFrom
	EndIf
	If iFrom > iTo
		Int iTemp = iTo
		iTo = iFrom
		iFrom = iTemp
	EndIf
	Int[] iArr = Utility.CreateIntArray((iTo - iFrom) + 1,iFrom)
	Int i = 0
	Int j = 0
	int c = 0
	Int iIndex = 0
	Int iNum
	Bool bConflict = False
	While iIndex < iArr.Length
		iNum = iIndex + iFrom
		bConflict = False
		j = 0
		While !bConflict && j < iExcludes.Length
			If iExcludes[j] == iNum
				bConflict = True
			EndIf
			j += 1
		EndWhile
		If !bConflict
			iArr[i] = iNum
			i += 1
			c += 1
		EndIf
		iIndex += 1
	EndWhile
	If c == 0
		Return iFrom
	EndIf
	Return iArr[Utility.RandomInt(iFrom,iFrom + c - 1)]
EndFunction

Int Function ichangeVar(Int iVar,Int iMin,Int iMax, Int iAmount ) Global
{increase or decrease a global variable by an amount between In a circle between iMin and iMax.}
	iVar = ( iVar + iAmount )
	If ( iVar > iMax )
		iVar = iMin
	ElseIf ( iVar < iMin )
		iVar = iMax
	EndIf
	Return iVar
EndFunction

Int Function RandomIntWithExclusionArray( Int iFrom, Int iTo, Bool[] iFlagArray) Global
{Generates a random integer between iFrom and iTo (inclusive), excluding false values with the same index in a bool array}
	If iFrom == iTo
		If iFlagArray[iFrom]
			Return iFrom
		EndIf
		Return -1
	ElseIf iFrom > iTo
		Int iTemp = iFrom
		iFrom = iTo
		iTo = iTemp
	EndIf
	Int ExcludeCount = 0
	Int iIndex = iFrom
	While iIndex <= iTo
		If (!iFlagArray[iIndex])
			ExcludeCount += 1
		EndIf
		iIndex += 1
	Endwhile
	If ExcludeCount > (iTo - iFrom)
		Return -1
	EndIf
	Int iRandom = Utility.RandomInt(iFrom, iTo - ExcludeCount)
	 iIndex = iFrom 
	 While (iIndex <= iTo)
		If ( iRandom < iIndex )
			Return iRandom
		ElseIf (( iRandom >= iIndex ) && !iFlagArray[iIndex])
			iRandom += 1
		EndIf
		iIndex += 1
	EndWhile
	Return iRandom
EndFunction

Int Function RandomIntWithShuffledExclusionArray( Int iFrom, Int iTo, Bool[] iFlagArray, Int[] iIndexArray) Global
{Generates a random integer between iFrom and iTo (inclusive), excluding false values in a bool array with the same index using a Int array for indexes.}
	If iFrom == iTo
		If iFlagArray[iIndexArray[iFrom]]
			Return iFrom
		EndIf
		Return -1
	ElseIf iFrom > iTo
		Int iTemp = iFrom
		iFrom = iTo
		iTo = iTemp
	EndIf
	Int ExcludeCount = 0
	int iIndex = iFrom
	While iIndex <= iTo
		If (!iFlagArray[iIndexArray[iIndex]])
			ExcludeCount += 1
		EndIf
		iIndex += 1
	Endwhile
	If ExcludeCount > (iTo - iFrom)
		Return -1
	EndIf
	Int iRandom = Utility.RandomInt(iFrom, iTo - ExcludeCount)
	 iIndex = iFrom 
	 While (iIndex <= iTo)
		If ( iRandom < iIndex )
			Return iRandom
		ElseIf (( iRandom >= iIndex ) && !iFlagArray[iIndexArray[iIndex]])
			iRandom += 1
		EndIf
		iIndex += 1
	EndWhile
	Return iRandom
EndFunction

Function iArrayClear(Int[] Arr) Global
{clear an int array.}
	If Arr
		int i = Arr.Length
		While i > 0 
			i -= 1
			Arr[i] = 0
		EndWhile
	EndIf
EndFunction

Function fArrayClear(Float[] Arr) Global
{clear a float array.}
	If Arr
		Int i = Arr.Length
		While i > 0 
			i -= 1
			Arr[i] = 0
		EndWhile
	EndIf
EndFunction 

Function kArrayClear(Form[] Arr) Global
{clear a form array.}
	If Arr
		Int i = Arr.Length
		While i > 0 
			i -= 1
			Arr[i] = None
		EndWhile
	EndIf
EndFunction 

String Function sDecToHex(Int iDec) Global
{Convert a decimal integer to hexadecimal}
	Bool bNegetive = False
	If iDec <= 0
		If iDec == 0
			Return "00000000"
		Else
			iDec *= -1
			bNegetive = True
		EndIf
	EndIf
	String sHexes = "0123456789ABCDEF"
	String r = ""
	Bool bAddOne = True
	Int n = iDec
	Int i
	While True
		If bNegetive
			i = 15 - (n % 16)
			If bAddOne
				i += 1
				If i == 16
					i = 0
				Else
					bAddOne = False
				EndIf
			EndIf
		Else
			i = n % 16
		EndIf
		r += GetNthChar(sHexes,i)
		n = (n / 16) As Int
		if n == 0
			String sResult = ""
			n = GetLength(r)
			While n > 0
				n -= 1
				sResult += GetNthChar(r, n)
			EndWhile
			If GetLength(sResult) < 8
				If bNegetive
					Return Substring("FFFFFFFF", 0, 8 - GetLength(sResult)) + sResult
				Else
					Return Substring("00000000", 0, 8 - GetLength(sResult)) + sResult
				EndIf
			EndIf
			Return sResult
		EndIf
	EndWhile
EndFunction

Bool Function bIsInteger(String s) Global
{Checking if string is an integer.}
	Int i = GetLength(s)
	If i == 0
		Return False
	EndIf
	String c = ""
	While i > 0
		i -= 1
		c = GetNthChar(s,i)
		If i > 0
			If !StringUtil.IsDigit(c)
				Return False
			EndIf
		ElseIf GetLength(s) > 1 ;s should not be '-' or '+'
			If !StringUtil.IsDigit(c) && c != "-" && c != "+"
				Return False
			EndIf
		EndIf
	EndWhile
	Return True
EndFunction

Bool Function stopAndConfirm(Quest akQuest, Float afSecs = 3.0, Int aiStage = -1) Global
{stop a quest and wait for it to stop, optionaly set stage of the quest to a stage that would stop it.}
	If !akQuest.IsRunning()
		Return True
	EndIf
	If aiStage > -1
		akQuest.SetStage(aiStage)
	Else
		akQuest.Stop()
	EndIf
	Int i = 0
	While (i * 0.1) < afSecs && akQuest.IsRunning()
		Utility.Wait(0.1)
		i += 1
	EndWhile
	Return !akQuest.IsRunning() 
EndFunction

Function disintegrateWhenAble(Actor akActor) Global
{remove a leveled actor from the game when player is not around.}
	While akActor && akActor.GetParentCell() && akActor.GetParentCell().IsAttached()
		Utility.Wait(5)
	EndWhile
	akActor && akActor.RemoveAllItems()
	akActor && akActor.SetCriticalStage(akActor.CritStage_DisintegrateEnd)
	akActor && akActor.DisableNoWait()
EndFunction

Function disintegrateNow(Actor akActor) Global
{remove a leveled actor from the game instantly.}
	akActor && akActor.RemoveAllItems()
	akActor && akActor.SetCriticalStage(akActor.CritStage_DisintegrateEnd)
	akActor && akActor.DisableNoWait()
EndFunction

Function stopBrawlQuest(Quest akBrawlQuest, Int akEndStage) Global
{Stop a brawling quest by setting the stage to the stop stage and revive the player character from bleedout.}
	akBrawlQuest.SetStage(akEndStage)
	Utility.Wait(1.0)
	Game.GetPlayer().ResetHealthAndLimbs()
	Game.GetPlayer().StopCombatAlarm()
EndFunction

Int Function randIntFromlimitedRange(Int iMin, Int iMax, Int iLimit, Int iMinValue, Int iMaxValue) Global
{Generates a random integer between iMin and iMax (inclusive), and limit the result between a range.}
	Int MinAmount = iMin
	Int MaxAmount = iMax
	If MinAmount > iLimit
		Return 0
	Else
		If MinAmount > iMaxValue
			MinAmount = iMaxValue
		EndIf
		If MinAmount < iMinValue
			MinAmount = iMinValue
		EndIf
		If MaxAmount > iMaxValue || MaxAmount <= iMinValue
			MaxAmount = iMaxValue
		EndIf
		If MaxAmount < MinAmount
			Int tmp = MinAmount
			MinAmount = MaxAmount
			MaxAmount = tmp
		EndIf
	EndIf
	Return Utility.RandomInt(MinAmount,MaxAmount)
EndFunction

Function killPlayer() Global
{kill the player even if the player is essential or Invulnerable or god mod is active.}
	Actor player = Game.GetPlayer()
	ActorBase playerBase = player.GetBaseObject() As ActorBase
	Debug.SetGodMode(False)
	playerBase.SetInvulnerable(False)
	playerBase.SetEssential(0)
	player.Kill()
EndFunction

String Function shortenString(String sString, Int iLimit) Global
{shorten the input string and put ... at the end of it.}
	Int iLen = GetLength(sString)
	If iLimit < 4
		If iLimit < 1
			Return sString
		EndIf
		If iLen > iLimit
			Return Substring(sString,0,iLimit)
		EndIf
		Return sString
	ElseIf iLen < 4
		Return sString
	EndIf
	If iLen > iLimit
		Return Substring(sString, 0, len = iLimit - 3) + "..."
	EndIf
	Return sString
EndFunction

FormList Function checkAndFixFormList(FormList akList, Bool abCheckSize = False, Bool abOnlyRef = False, Bool abDeleteBrokenRefs = False) Global
{fix a Form list by removing nones,invalid refs and reducing its size to 128.}	
	Bool bHasNone = False
	Int i = 0
	While i < akList.GetSize() && !bHasNone
		bHasNone = !akList.GetAt(i)
		i += 1
	EndWhile
	If bHasNone || abOnlyRef || (abCheckSize && akList.GetSize() > 128)
		Form[] kArr 
		If akList.GetSize() > 128
			kArr = New Form[128]
			i = 0
			While i < 128
				kArr[i] = akList.GetAt(i) As Form
				i += 1
			EndWhile
		Else
			kArr = akList.ToArray()
		EndIf
		akList.Revert()
		ObjectReference kRef
		i = 0
		While i < kArr.Length
			If kArr[i]
				If abOnlyRef
					If kArr[i] As ObjectReference
						kRef = kArr[i] As ObjectReference
						If kRef.GetParentCell() || kRef.GetWorldSpace()
							akList.AddForm(kArr[i])
						ElseIf abDeleteBrokenRefs
							kRef.DisableNoWait()
							kRef.Delete()
						EndIf
					EndIf
				Else
					akList.AddForm(kArr[i])
				EndIf	
			EndIf
			i += 1
		EndWhile
	EndIf
	Return akList
EndFunction

Form Function getFromMergedFormList(FormList akMergedlist,Int aiIndex = 0) Global
{get a value by index from a formlist of formlists by using an index that is betwwen 0 and sum of the size of all formlists in the formlist minus 1.}
	Int i = 0
	While i < akMergedlist.GetSize() && aiIndex > -1
		If aiIndex < (akMergedlist.GetAt(i) As FormList).GetSize()
			Return (akMergedlist.GetAt(i) As FormList).GetAt(aiIndex)
		EndIf
		aiIndex -= (akMergedlist.GetAt(i) As FormList).GetSize()
		i += 1
	EndWhile
	Return None
EndFunction

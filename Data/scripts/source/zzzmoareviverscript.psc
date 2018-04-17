Scriptname zzzmoaReviverScript extends ReferenceAlias 

Quest Property moaReviveMCMscript Auto
Message Property moaReviveMenu1 Auto
GlobalVariable Property moaState Auto
GlobalVariable Property moaArkayMarkRevive  Auto
GlobalVariable Property moaDragonSoulRevive  Auto
GlobalVariable Property moaBSoulGemRevive  Auto
GlobalVariable Property moaGSoulGemRevive  Auto
GlobalVariable Property moaSeptimRevive  Auto
GlobalVariable Property moaBleedoutHandlerState Auto
GlobalVariable Property moaBleedouAnimation Auto
zzzmoaReviveMCM Property ConfigMenu Auto
MiscObject Property Gold001 Auto
MiscObject Property MarkOfArkay Auto
SoulGem Property BlackFilledGem Auto
SoulGem Property GrandFilledGem Auto
Actor Property PlayerRef Auto
VisualEffect Property VisMagDragonAbsorbEffect Auto
VisualEffect property VisMagDragonAbsorbManEffect Auto
EffectShader Property EffectHealCirclFXS Auto
Sound property SoundNPCDragonDeathSequenceWind auto
Sound property SoundNPCDragonDeathSequenceExplosion auto
Sound property SoulAbsorbWind auto
Sound property SoulAbsorbExplosion auto
FormList property ArkayAmulets Auto
FormList Property QuestBlackList Auto
FormList property MarkerList Auto
FormList Property LocationBlackList Auto
Formlist Property CityMarkersList Auto
MagicEffect property FortifyHealthFFSelf Auto
Spell Property moaReviveAfterEffect Auto
Spell Property BleedoutProtection Auto
Spell Property MoveCustomMarker Auto
Spell Property RecallMarker Auto
Spell Property ArkayCurse Auto
Spell Property ArkayCurseAlt Auto
MagicEffect property AutoReviveSelf Auto
ImageSpaceModifier Property FadeOut Auto
ImageSpaceModifier Property BlackScreen Auto
ImageSpaceModifier Property FadeIn Auto
ImageSpaceModifier Property LowHealthImod Auto
ObjectReference Property CustomMarker Auto
ObjectReference Property PlayerMarker Auto
ObjectReference Property SleepMarker Auto
ObjectReference Property DetachMarker1 Auto
ObjectReference Property DetachMarker2 Auto
ObjectReference Property DetachMarker3 Auto
Objectreference Property CellLoadMarker Auto
ObjectReference Property LocationMarker Auto
Objectreference Property CellLoadMarker2 Auto
ObjectReference Property LocationMarker2 Auto
Objectreference Property LostItemsMarker Auto
ObjectReference Property LostItemsChest Auto
ObjectReference Property EquippedItemsChest Auto
ObjectReference Property ValuableItemsChest Auto
Cell Property DefaultCell Auto
Bool Property bIsItemsRemoved Auto
Float Property fLostSouls Auto
Actor Property Victim Auto
Actor Property Attacker Auto
Quest Property moaRetrieveLostItems Auto
FormList property WorldspacesInterior auto
Formlist property ExternalMarkerList Auto
Quest Property WerewolfQuest Auto
Quest Property VampireLordQuest Auto
Formlist Property PotionList Auto
FormList Property LocationsList Auto
Form[] Property VItemArr Auto Hidden
Int Property iTotalBleedOut = 0 Auto Hidden
Int Property iTotalRespawn = 0 Auto Hidden
Int Property iTotalRevives = 0 Auto Hidden
Int Property iRevivesByTrade = 0 Auto Hidden
Int Property iRevivesByRevivalSpell = 0 Auto Hidden
Int Property iRevivesBySacrificeSpell = 0 Auto Hidden
Int Property iRevivesByPotion = 0 Auto Hidden
Int Property iDestroyedItems = 0 Auto Hidden
Form[] Property Equipment Auto Hidden
ObjectReference[] Property ExcludedMarkerList Auto Hidden
Location Property PaleHoldLocation  Auto
Location Property HjaalmarchHoldLocation  Auto
Keyword property HoldKeyword Auto
Quest Property CidhnaMineJailEventScene Auto
Objectreference Property RiftenJailMarker Auto
Objectreference Property WhiterunJailMarker Auto
Objectreference Property FalkreathJailMarker Auto
Objectreference Property WindhelmJailMarker Auto
Objectreference Property MarkarthJailMarker Auto
Objectreference Property WinterholdJailMarker Auto
Objectreference Property DawnstarJailMarker Auto
Objectreference Property MorthalJailMarker Auto
Objectreference Property SolitudeJailMarker Auto
Objectreference Property DLC2RavenRockJailMarker Auto
Faction Property CrimeFactionPale  Auto
Faction Property CrimeFactionFalkreath  Auto
Faction Property CrimeFactionReach  Auto
Faction Property CrimeFactionHjaalmarch  Auto
Faction Property CrimeFactionHaafingar  Auto
Faction Property CrimeFactionRift  Auto
Faction Property CrimeFactionWhiterun  Auto
Faction Property CrimeFactionEastmarch  Auto
Faction Property CrimeFactionWinterhold  Auto
Faction Property DLC2CrimeRavenRockFaction Auto
Race Property WereWolfBeastRace Auto
Race Property DLC1VampireBeastRace Auto

Bool bCidhnaJail
Bool bDidItemsRemoved
Bool  bSeptimRevive  
Bool  bDragonSoulRevive  
Bool  bBSoulGemRevive  
Bool  bGSoulGemRevive 
Bool  bArkayMarkRevive
Bool  bPotionRevive
Float[] PriorityArray
Int iChoice
Bool bIsPlayerRagdoll
Bool bHasAutoReviveEffect
Int iArkayMarkCount
Int iBSoulGemCount
Int iGSoulGemCount
Float fDragonSoulCount
Int iSeptimCount
Int iRespawnPointsCount
String strRemovedItem
Form LeftHandEquippedItem
Form RightHandEquipedItem
bool bInBleedout
Int iRemovableItems

State Bleedout1
	Event OnPlayerLoadGame()
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		If akBaseObject as Armor
			If Equipment.find(akBaseObject) < 0
				Int iEmpty = Equipment.Find(None)
				If iEmpty > -1
					Equipment[iEmpty] = akBaseObject
				EndIf
			EndIf
			PlayerRef.RemoveItem(akBaseObject, 1, True, EquippedItemsChest)
		EndIf
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
EndState

State Bleedout2
	Event OnPlayerLoadGame()
	EndEvent
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		If akBaseObject as Armor
			If Equipment.find(akBaseObject) < 0
				Int iEmpty = Equipment.Find(None)
				If iEmpty > -1
					Equipment[iEmpty] = akBaseObject
				EndIf
			EndIf
			PlayerRef.RemoveItem(akBaseObject, 1, True, EquippedItemsChest)
		EndIf
	EndEvent
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent
EndState

Event OnInit()
	If !moaReviveMCMscript.IsRunning()
		moaReviveMCMscript.Start()
	EndIf
	moaState.SetValue(1)
	PlayerRef.GetActorBase().SetEssential(True)
	PlayerRef.SetNoBleedoutRecovery(True)
	moaBleedoutHandlerState.SetValue(0)
	PriorityArray = new Float[5]
	SetVars()
	SetGameVars()
	RegisterForSleep()
	PlayerRef.AddSpell(MoveCustomMarker)
	PlayerRef.AddSpell(RecallMarker)
	DetachMarker2.Enable()
	DetachMarker2.MoveTo(PlayerRef)
	Debug.notification("$mrt_MarkofArkay_Notification_Init")
EndEvent

Event OnPlayerLoadGame()
	If ConfigMenu.bIsEffectEnabled
		Debug.SetGodMode(True) ;because when loading a save game usually npcs start moving before player
	EndIf
	SetGameVars()
	Utility.Wait(3.0)
	Debug.SetGodMode(False)
EndEvent

Event OnEnterBleedout()
	BleedoutHandler(ToggleState())
EndEvent

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	If ( PlayerRef.GetParentCell() != DefaultCell )
		SleepMarker.Enable()
		SleepMarker.MoveTo(PlayerRef)
		SleepMarker.SetPosition(PlayerRef.GetPositionx(), PlayerRef.GetPositiony(), PlayerRef.GetPositionz())
		SleepMarker.SetAngle(0.0, 0.0, PlayerRef.GetAnglez())
		If ConfigMenu.bAutoSwitchRP
			ConfigMenu.iTeleportLocation = ( ConfigMenu.sRespawnPoints.Length - 4 )
		EndIf
	EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference) ; using equiped spells as workaround a bug which happens when player goes to bleedout while fighting with spell
	If ( !PlayerRef.IsBleedingOut() && GetState() == "")
		Utility.Wait(0.5)
		If PlayerRef.GetEquippedItemType(0) != 0
			LeftHandEquippedItem = PlayerRef.GetEquippedObject(0)
		Else
			LeftHandEquippedItem = None
		EndIf
		If PlayerRef.GetEquippedItemType(1) != 0
			RightHandEquipedItem = PlayerRef.GetEquippedObject(1)
		Else
			RightHandEquipedItem = None
		EndIf
	EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference) ;SKSE
    If (!PlayerRef.IsBleedingOut() && GetState() == "")
		If PlayerRef.GetEquippedItemType(0) != 0
			LeftHandEquippedItem = PlayerRef.GetEquippedObject(0)
		Else
			LeftHandEquippedItem = None
		EndIf
		If PlayerRef.GetEquippedItemType(1) != 0
			RightHandEquipedItem = PlayerRef.GetEquippedObject(1)
		Else
			RightHandEquipedItem = None
		EndIf
	EndIf
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerattack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	Attacker = akAggressor as Actor
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	If moaBleedoutHandlerState.GetValue() == 0
		LocationMarker2.Enable()
		LocationMarker2.MoveTo(LocationMarker)
		LocationMarker.Enable()
		LocationMarker.MoveTo(PlayerRef)
	EndIf
EndEvent

Event OnCellLoad()
	If moaBleedoutHandlerState.GetValue() == 0
		CellLoadMarker2.Enable()
		CellLoadMarker2.MoveTo(CellLoadMarker)
		CellLoadMarker.Enable()
		CellLoadMarker.MoveTo(PlayerRef)
	EndIf
EndEvent

String Function ToggleState() ;prevents double menu when player revived with potion and returns to bleedout while previous bleedout event is not finished
	If (GetState() == "Bleedout1")
		GoToState("Bleedout2")
		Return "Bleedout2"
	Else
		GoToState("Bleedout1")
		Return "Bleedout1"
	EndIf
Endfunction

Function BleedoutHandler(String CurrentState)
	If ConfigMenu.bIsEffectEnabled
		BleedoutProtection.Cast(PlayerRef)
	Else
		Debug.SetGodMode(True)
	EndIf
	Game.DisablePlayerControls()
	Game.EnableFastTravel(False)
	If iTotalBleedOut < 99999999
		iTotalBleedOut += 1
	EndIf
	If ( ConfigMenu.bIsRevivalEnabled &&  PlayerRef.IsSwimming() && !WerewolfQuest.IsRunning() ) ;SKSE
		PlayerRef.SetActorValue("Paralysis",1)
		PlayerRef.PushActorAway(PlayerRef,0)
		bIsPlayerRagdoll = True
		Game.ForceThirdPerson() ; fix camera bug 
	Else
		bIsPlayerRagdoll = False
	EndIf
	moaBleedoutHandlerState.SetValue(1)
	LowHealthImod.Remove()
	SetVars()
	strRemovedItem = ""
	bHasAutoReviveEffect = PlayerRef.HasMagicEffect(AutoReviveSelf)
	;PlayerRef.StopCombatAlarm()
	If !ConfigMenu.bIsRevivalEnabled
		If !ConfigMenu.bIsEffectEnabled
			Debug.SetGodMode(False)
		EndIf
		Game.EnablePlayerControls()
		Game.EnableFastTravel(True)
		moaBleedoutHandlerState.SetValue(0)
		LowHealthImod.Remove()
		GoToState("")
		Return
	EndIf
	If PlayerRef.GetActorValue("health") < -10
		PlayerRef.RestoreActorValue( "health", -10 - PlayerRef.GetActorValue("health") )
	EndIf
	If ConfigMenu.bAutoDrinkPotion && !bInBeastForm()
		Int iPotion = iHasHealingPotion()
		If iPotion > -1
			Utility.Wait(ConfigMenu.fBleedoutTimeSlider)
			If !PlayerRef.IsBleedingOut()
				If bIsPlayerRagdoll
					PlayerRef.SetActorValue("Paralysis",0)
				EndIf
				RequipSpells()
				PlayerRef.ResetHealthAndLimbs()
				If ConfigMenu.bIsEffectEnabled
					PlayerRef.DispelSpell(BleedoutProtection)
				Else
					Debug.SetGodMode(False)
				EndIf
				Game.ForceThirdPerson()
				Game.EnablePlayerControls()
				Game.EnableFastTravel(True)
				If iTotalRevives < 99999999
					iTotalRevives += 1
				EndIf
				moaBleedoutHandlerState.SetValue(0)
				LowHealthImod.Remove()
				GoToState("")
				Return
			Else
				If bIsPlayerRagdoll
					PlayerRef.SetActorValue("Paralysis",0)
				EndIf
				If ConfigMenu.bIsNotificationEnabled
					Debug.Notification("$mrt_MarkofArkay_Notification_Revive_Potion")
				EndIf
				If ConfigMenu.bIsEffectEnabled
					moaReviveAfterEffect.Cast(PlayerRef)
				EndIf
				RequipSpells()
				Debug.SetGodMode(True)
				PlayerRef.ResetHealthAndLimbs()
				Utility.Wait(0.1)
				PlayerRef.EquipItem(PotionList.GetAt(iPotion) As Potion, False, True)
				If ConfigMenu.bIsEffectEnabled
					BleedoutProtection.Cast(PlayerRef)
				EndIf
				Debug.SetGodMode(False)
				Game.ForceThirdPerson()
				Game.EnablePlayerControls()
				Game.EnableFastTravel(True)
				If iRevivesByPotion < 99999999
					iRevivesByPotion += 1
				EndIf
				If iTotalRevives < 99999999
					iTotalRevives += 1
				EndIf
				moaBleedoutHandlerState.SetValue(0)
				LowHealthImod.Remove()
				GoToState("")
				Return
			EndIf
		EndIf
	EndIf
	If ( bIsRevivable() || bPotionRevive || bHasAutoReviveEffect || Victim )
		If !bPotionRevive || bHasAutoReviveEffect || Victim || bInBeastForm()
			Utility.Wait(ConfigMenu.fBleedoutTimeSlider)
		Else
			Game.EnablePlayerControls()
			;PlayerRef.StopCombatAlarm()
			Debug.SetGodMode(False)
			Utility.Wait(ConfigMenu.fBleedoutTimeSlider)
		EndIf
		If (GetState() != CurrentState) ; player revived with a potion but returned to bleedout in less than 6 secs
			Return
		ElseIf !PlayerRef.IsBleedingOut() ;player revived with potion or another script and is alive after 6 secs
			If bPotionRevive && ConfigMenu.bIsEffectEnabled
				moaReviveAfterEffect.Cast(PlayerRef)
			EndIf
			If bIsPlayerRagdoll
				PlayerRef.SetActorValue("Paralysis",0)
			EndIf
			RequipSpells()
			PlayerRef.ResetHealthAndLimbs()
			If iTotalRevives < 99999999
				iTotalRevives += 1
			EndIf
			If !bPotionRevive
				If ConfigMenu.bIsEffectEnabled
					PlayerRef.DispelSpell(BleedoutProtection)
				Else
					Debug.SetGodMode(False)
				EndIf
			EndIf
			Game.ForceThirdPerson()
			Game.EnablePlayerControls()
			Game.EnableFastTravel(True)
			moaBleedoutHandlerState.SetValue(0)
			LowHealthImod.Remove()
			GoToState("")
		ElseIf bHasAutoReviveEffect ;player has cast a revive spell or scroll
			If ConfigMenu.bIsEffectEnabled
				VisMagDragonAbsorbEffect.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
				VisMagDragonAbsorbManEffect.play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
				SoulAbsorbWind.play(PlayerRef) 
				SoulAbsorbExplosion.play(PlayerRef) 
				EffectHealCirclFXS.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider + 1.0)
			EndIf
			Utility.Wait(ConfigMenu.fRecoveryTimeSlider)
			If ConfigMenu.bIsEffectEnabled
				moaReviveAfterEffect.Cast(PlayerRef)
			EndIf
			RequipSpells()
			If ConfigMenu.bIsNotificationEnabled
				Debug.Notification("$mrt_MarkofArkay_Notification_Revive_Revival_Scroll")
			EndIf
			RevivePlayer(True)
			If iRevivesByRevivalSpell < 99999999
				iRevivesByRevivalSpell += 1
			EndIf
			If iTotalRevives < 99999999
				iTotalRevives += 1
			EndIf
		ElseIf (Victim && !Victim.IsDead()) ; player has cast a sacrifice spell or scroll on someone
			Victim.Kill()
			Victim = None
			If ConfigMenu.bIsEffectEnabled
				VisMagDragonAbsorbEffect.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
				VisMagDragonAbsorbManEffect.play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
				SoulAbsorbWind.play(PlayerRef) 
				SoulAbsorbExplosion.play(PlayerRef) 
				EffectHealCirclFXS.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider + 1.0)
			EndIf
			Utility.Wait(ConfigMenu.fRecoveryTimeSlider)
			If ConfigMenu.bIsEffectEnabled
				moaReviveAfterEffect.Cast(PlayerRef)
			EndIf
			RestoreLostItems(PlayerRef)
			RequipSpells()
			RevivePlayer(True)
			If iRevivesBySacrificeSpell < 99999999
				iRevivesBySacrificeSpell += 1
			EndIf
			If iTotalRevives < 99999999
				iTotalRevives += 1
			EndIf
			If ConfigMenu.bIsNotificationEnabled
				Debug.Notification("$mrt_MarkofArkay_Notification_Revive_Sacrifice_Scroll")
			EndIf
			If ( ConfigMenu.bLostItemQuest || moaRetrieveLostItems.IsRunning() )
				moaRetrieveLostItems.SetStage(20)
			EndIf
		ElseIf bIsRevivable()
			If ConfigMenu.bIsMenuEnabled
				Bool bResult = RemoveItemByMenu()
				If bResult
					If ConfigMenu.bIsEffectEnabled
						VisMagDragonAbsorbEffect.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
						VisMagDragonAbsorbManEffect.play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
						SoulAbsorbWind.play(PlayerRef) 
						SoulAbsorbExplosion.play(PlayerRef) 
						EffectHealCirclFXS.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider + 1)
					EndIf
					Utility.Wait(ConfigMenu.fRecoveryTimeSlider)
					If ConfigMenu.bIsEffectEnabled
						moaReviveAfterEffect.Cast(PlayerRef)
					EndIf
					RequipSpells()
					ShowNotification()
					RevivePlayer(True)
					If iRevivesByTrade < 99999999
						iRevivesByTrade += 1
					EndIf
					If iTotalRevives < 99999999
						iTotalRevives += 1
					EndIf
				Else
					RevivePlayer(False)
				EndIf
			Else
				PriorityArray = new Float[5]
				PriorityArray[0] = ConfigMenu.fGoldPSlider + 10   ; adding this numbers to Priorities so after sorting them by ones, they still be distinguishable 
				PriorityArray[1] = ConfigMenu.fDragonSoulPSlider + 20
				PriorityArray[2] = ConfigMenu.fBSoulgemPSlider + 30
				PriorityArray[3] = ConfigMenu.fMarkPSlider + 40
				PriorityArray[4] = ConfigMenu.fGSoulgemPSlider + 50
				SortPriorityArray() 
				Int i = 4
				Bool bBreak = False
				While (i>-1) && !bBreak 
					If PriorityArray[i]>50 && bGSoulGemRevive ; player has enough grand soul gem and its Priority is higher
						AutoRemoveItem(i)
						bBreak = True
					Elseif PriorityArray[i]>40 && (PriorityArray[i]<50) && bArkayMarkRevive
						AutoRemoveItem(i)
						bBreak = True
					Elseif (PriorityArray[i]>30) && (PriorityArray[i]<40) && bBSoulGemRevive
						AutoRemoveItem(i)
						bBreak = True
					Elseif (PriorityArray[i]>20) && (PriorityArray[i]<30) && bDragonSoulRevive
						AutoRemoveItem(i)
						bBreak = True
					Elseif (PriorityArray[i]>10) && (PriorityArray[i]<20) && bSeptimRevive
						AutoRemoveItem(i)
						bBreak = True					
					EndIf 
					i-=1
				EndWhile
				If bBreak ;player has traded 
					If ConfigMenu.bIsEffectEnabled
						VisMagDragonAbsorbEffect.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
						VisMagDragonAbsorbManEffect.play(PlayerRef, ConfigMenu.fRecoveryTimeSlider)
						SoulAbsorbWind.play(PlayerRef) 
						SoulAbsorbExplosion.play(PlayerRef) 
						EffectHealCirclFXS.Play(PlayerRef, ConfigMenu.fRecoveryTimeSlider + 1)
					EndIf
					Utility.Wait(ConfigMenu.fRecoveryTimeSlider)
					If ConfigMenu.bIsEffectEnabled
						moaReviveAfterEffect.Cast(PlayerRef)
					EndIf
					RequipSpells()
					ShowNotification()
					RevivePlayer(True)
					If iRevivesByTrade < 99999999
						iRevivesByTrade += 1
					EndIf
					If iTotalRevives < 99999999
						iTotalRevives += 1
					EndIf
				Else ; player couldn't trade
					RevivePlayer(False)
				EndIf
			EndIf
		Else
			RevivePlayer(False)
		EndIf
	Else
		Utility.Wait(ConfigMenu.fBleedoutTimeSlider)
		If !PlayerRef.IsBleedingOut()
			If bIsPlayerRagdoll
				PlayerRef.SetActorValue("Paralysis",0)
			EndIf
			RequipSpells()
			PlayerRef.ResetHealthAndLimbs()
			If ConfigMenu.bIsEffectEnabled
				PlayerRef.DispelSpell(BleedoutProtection)
			Else
				Debug.SetGodMode(False)
			EndIf
			Game.ForceThirdPerson()
			Game.EnablePlayerControls()
			Game.EnableFastTravel(True)
			If iTotalRevives < 99999999
				iTotalRevives += 1
			EndIf
			moaBleedoutHandlerState.SetValue(0)
			LowHealthImod.Remove()
			GoToState("")
		Else
			RevivePlayer(False)
		EndIf
	EndIf
Endfunction

Function SortPriorityArray () ;sort priority so higher priority and those items that can be traded are first 
	Int Index1
	Int Index2 = PriorityArray.Length - 1
	Bool bIsIndex1 = False 
	Bool bIsIndex2 = False 
	While (Index2 > 0)
		Index1 = 0
		While (Index1 < Index2)
			If (((PriorityArray [Index1] as Int) % 10) > (((PriorityArray [Index1 + 1] as Int) % 10))) ;ones are priorities tens are for being distinguishable after sort
				Float SwapDummy = PriorityArray [Index1]
				PriorityArray [Index1] = PriorityArray [Index1 + 1]
				PriorityArray [Index1 + 1] = SwapDummy
			Elseif (((PriorityArray [Index1] as Int) % 10) == (((PriorityArray [Index1 + 1] as Int) % 10))) ; when two item has the same priority
				If (PriorityArray[Index1]>50) && bGSoulGemRevive
					bIsIndex1 = True ;  Item at index 1 is tradable
				Elseif (PriorityArray[Index1]>40) && (PriorityArray[Index1]<50) && bArkayMarkRevive
					bIsIndex1 = True
				Elseif (PriorityArray[Index1]>30) && (PriorityArray[Index1]<40) && bBSoulGemRevive
					bIsIndex1 = True
				Elseif (PriorityArray[Index1]>20) && (PriorityArray[Index1]<30) && bDragonSoulRevive
					bIsIndex1 = True
				Elseif (PriorityArray[Index1]>10) && (PriorityArray[Index1]<20) && bSeptimRevive
					bIsIndex1 = True
				EndIf
				If (PriorityArray[Index1 + 1]>50) && bGSoulGemRevive
					bIsIndex2 = True ; Item at index 2 is tradable
				Elseif (PriorityArray[Index1 + 1]>40) && (PriorityArray[Index1 + 1]<50) && bArkayMarkRevive
					bIsIndex2 = True
				Elseif (PriorityArray[Index1 + 1]>30) && (PriorityArray[Index1 + 1]<40) && bBSoulGemRevive
					bIsIndex2 = True
				Elseif (PriorityArray[Index1 + 1]>20) && (PriorityArray[Index1 + 1]<30) && bDragonSoulRevive
					bIsIndex2 = True
				Elseif (PriorityArray[Index1 + 1]>10) && (PriorityArray[Index1 + 1]<20) && bSeptimRevive
					bIsIndex2 = True
				EndIf
				If (bIsIndex1 == True) && (bIsIndex2 == False) ;tradable items should have lower index in the array after sort
					Float SwapDummy = PriorityArray [Index1]
					PriorityArray [Index1] = PriorityArray [Index1 + 1]
					PriorityArray [Index1 + 1] = SwapDummy 
				EndIf
				bIsIndex1 = False 
				bIsIndex2 = False
			EndIf
			Index1 += 1
		EndWhile
		Index2 -= 1
	EndWhile
EndFunction

Int Function Min(Int a,Int b)
	If a <= b
		Return a
	EndIf
	Return b
EndFunction

Bool Function RemoveItemByMenu() ;trade by using menu
	Bool bRevive = False
	iChoice = moaReviveMenu1.Show(iArkayMarkCount,iBSoulGemCount,fDragonSoulCount as Int,iGSoulGemCount,iSeptimCount)
	If ((iChoice == 0) && bArkayMarkRevive)
		PlayerRef.RemoveItem(MarkOfArkay,(ConfigMenu.fValueMarkSlider as Int),True)
		bRevive = True
		strRemovedItem = "Arkay Mark"
	Elseif ((iChoice == 1) && bBSoulGemRevive)
		PlayerRef.RemoveItem(BlackFilledGem,(ConfigMenu.fValueBSoulGemSlider as Int),True)
		bRevive = True
		strRemovedItem = "Black Soul Gem"
	Elseif ((iChoice == 2) && bDragonSoulRevive)
		PlayerRef.ModActorValue("DragonSouls", -ConfigMenu.fValueSoulSlider)
		bRevive = True
		strRemovedItem = "Dragon Soul"
	Elseif ((iChoice == 3) && bGSoulGemRevive)
		PlayerRef.RemoveItem(GrandFilledGem,(ConfigMenu.fValueGSoulGemSlider as Int),True)
		bRevive = True
		strRemovedItem = "Grand Soul Gem"
	Elseif ((iChoice == 4) && bSeptimRevive)
		PlayerRef.RemoveItem(Gold001,(ConfigMenu.fValueGoldSlider as Int),True)
		bRevive = True
		strRemovedItem = "Septim"
	Else
		bRevive = False
	EndIf
	Return bRevive
EndFunction

Function AutoRemoveItem(Int i) ;trade without menu
	Int j = i - 1
	Int count = 0
	Bool bBreak = False
	Int iRandom
	If ( i>0 ) && (((PriorityArray [j] as Int ) % 10) == ((PriorityArray [i] as Int ) % 10)) ; this item isn't the last item in the array and next item has the same priority as this item
		while (j>-1) && !bBreak ; checking if there is any other item with the same priority
			If (PriorityArray[j]>50) && bGSoulGemRevive
				If ((PriorityArray[j] as Int )%10) == ((PriorityArray[i] as Int )%10)
					count+=1
				Else
					bBreak = True
				EndIf
			Elseif (PriorityArray[j]>40) && (PriorityArray[j]<50) && bArkayMarkRevive
				If ((PriorityArray[j] as Int )%10) == ((PriorityArray[i] as Int )%10)
					count+=1
				Else
					bBreak = True
				EndIf
			Elseif (PriorityArray[j]>30) && (PriorityArray[j]<40) && bBSoulGemRevive
				If ((PriorityArray[j] as Int )%10) == ((PriorityArray[i] as Int )%10)
					count+=1
				Else
					bBreak = True
				EndIf
			Elseif (PriorityArray[j]>20) && (PriorityArray[j]<30) && bDragonSoulRevive
				If ((PriorityArray[j] as Int )%10) == ((PriorityArray[i] as Int )%10)
					count+=1
				Else
					bBreak = True
				EndIf
			Elseif (PriorityArray[j]>10) && (PriorityArray[j]<20) && bSeptimRevive
				If ((PriorityArray[j] as Int )%10) == ((PriorityArray[i] as Int )%10)
					count+=1
				Else
					bBreak = True
				EndIf
			Else
				bBreak = True
			EndIf
			j-=1
		EndWhile
		iRandom = i - Utility.RandomInt(0, count) ; selecting a random item from items with the same priority
		AutoRemoveItemByIndex(iRandom);
	Else
		AutoRemoveItemByIndex(i) ;next item has a lower priority
	EndIf
Endfunction

Function AutoRemoveItemByIndex(Int iIndex) ; removing item at iIndex
	If (PriorityArray[iIndex]>50) && bGSoulGemRevive
		PlayerRef.RemoveItem(GrandFilledGem,(ConfigMenu.fValueGSoulGemSlider as Int),True)
		strRemovedItem = "Grand Soul Gem"
	Elseif (PriorityArray[iIndex]>40) && (PriorityArray[iIndex]<50) && bArkayMarkRevive
		PlayerRef.RemoveItem(MarkOfArkay,(ConfigMenu.fValueMarkSlider as Int),True)
		strRemovedItem = "Arkay Mark"
	Elseif (PriorityArray[iIndex]>30) && (PriorityArray[iIndex]<40) && bBSoulGemRevive
		PlayerRef.RemoveItem(BlackFilledGem,(ConfigMenu.fValueBSoulGemSlider as Int),True)
		strRemovedItem = "Black Soul Gem"
	Elseif (PriorityArray[iIndex]>20) && (PriorityArray[iIndex]<30) && bDragonSoulRevive
		PlayerRef.ModActorValue("DragonSouls", -ConfigMenu.fValueSoulSlider)
		strRemovedItem = "Dragon Soul"
	Elseif (PriorityArray[iIndex]>10) && (PriorityArray[iIndex]<20) && bSeptimRevive
		PlayerRef.RemoveItem(Gold001,(ConfigMenu.fValueGoldSlider as Int),True)
		strRemovedItem = "Septim"
	EndIf
EndFunction

Function ShowNotification()
	If !ConfigMenu.bIsNotificationEnabled
		return
	EndIf
	Int totalRemainingLives = 0
	SetVars()
	If ( ConfigMenu.bIsRevivalEnabled )
		If !(strRemovedItem == "")
			If (strRemovedItem == "Arkay Mark")
				Debug.Notification("$mrt_MarkofArkay_Notification_ArkayMark_Removed" )
				Debug.Notification( ConfigMenu.fValueMarkSlider as Int )
			Elseif (strRemovedItem == "Black Soul Gem") 
					Debug.Notification( "$mrt_MarkofArkay_Notification_BSoulGem_Removed"  )
					Debug.Notification( ConfigMenu.fValueBSoulGemSlider as Int )
			Elseif (strRemovedItem == "Grand Soul Gem")
				Debug.Notification( "$mrt_MarkofArkay_Notification_GSoulGem_Removed" )
				Debug.Notification( ConfigMenu.fValueGSoulGemSlider as Int )
			Elseif (strRemovedItem == "Dragon Soul")
				Debug.Notification( "$mrt_MarkofArkay_Notification_DragonSoul_Removed" )
				Debug.Notification( ConfigMenu.fValueSoulSlider as Int )
			Elseif (strRemovedItem == "Septim")
				Debug.Notification( "$mrt_MarkofArkay_Notification_Septim_Removed" )
				Debug.Notification( ConfigMenu.fValueGoldSlider as Int )
			EndIf
		EndIf
		If (bArkayMarkRevive)
			If ConfigMenu.fValueMarkSlider == 0.0
			  return
			Else
				totalRemainingLives += ( iArkayMarkCount / ConfigMenu.fValueMarkSlider ) as Int
			EndIf
		EndIf
		If ( bBSoulGemRevive )
			If ConfigMenu.fValueBSoulGemSlider == 0.0
				return
			Else
				totalRemainingLives += ( iBSoulGemCount / ConfigMenu.fValueBSoulGemSlider ) as Int
			EndIf
		EndIf
		If ( bGSoulGemRevive )
			If ConfigMenu.fValueGSoulGemSlider == 0.0
				return
			Else
				totalRemainingLives += ( iGSoulGemCount / ConfigMenu.fValueGSoulGemSlider ) as Int
			EndIf
		EndIf
		If ( bDragonSoulRevive )
			If ConfigMenu.fValueSoulSlider == 0.0
				return
			Else
				totalRemainingLives += ( fDragonSoulCount / ConfigMenu.fValueSoulSlider ) as Int
			EndIf
		EndIf
		If ( bSeptimRevive )
			If ConfigMenu.fValueGoldSlider == 0.0
				return
			Else
				totalRemainingLives += ( iSeptimCount / ConfigMenu.fValueGoldSlider ) as Int
			EndIf
		EndIf
		If ( totalRemainingLives > 0 )
			Debug.Notification("$mrt_MarkofArkay_Notification_totalRemainingTrades")
			Debug.Notification(totalRemainingLives)
		Else
			Debug.notification("$mrt_MarkofArkay_Notification_NoRemainingTrades")
		EndIf
	EndIf
EndFunction

Function RevivePlayer(Bool bRevive)
	If bRevive
		If ConfigMenu.bShiftBack
			ShiftBack()
			If ConfigMenu.bIsEffectEnabled
				BleedoutProtection.Cast(PlayerRef)
			EndIf
		EndIf
		If bIsPlayerRagdoll
			PlayerRef.SetActorValue("Paralysis",0)
		EndIf
		PlayerRef.ResetHealthAndLimbs()
		Game.ForceThirdPerson()
		Debug.SetGodMode(False)
		If !bHasAutoReviveEffect && ( PlayerRef.HasSpell(ArkayCurse) || PlayerRef.HasSpell(ArkayCurseAlt) )
			PlayerRef.RemoveSpell(ArkayCurse)
			PlayerRef.RemoveSpell(ArkayCurseAlt)
			If !bIsItemsRemoved
				If ( LostItemsMarker.GetParentCell() != DefaultCell )
					LostItemsMarker.MoveToMyEditorLocation()
					LostItemsMarker.Disable()
				EndIf
				If ConfigMenu.bLostItemQuest || moaRetrieveLostItems.IsRunning()
					moaRetrieveLostItems.SetStage(20)
				EndIf
			EndIf
		EndIf
		Game.EnablePlayerControls()
		Game.EnableFastTravel(True)
		moaBleedoutHandlerState.SetValue(0)
		LowHealthImod.Remove()
		GoToState("")
	Else
		If ( ConfigMenu.iNotTradingAftermath == 0 ) || ( ConfigMenu.iNotTradingAftermath == 1 && !bCanTeleport() )
			Game.EnablePlayerControls()
			Game.EnableFastTravel(True)
			If !bIsPlayerRagdoll
				PlayerRef.SetActorValue("Paralysis",1)
				PlayerRef.PushActorAway(PlayerRef,0)
			EndIf
			If !ConfigMenu.bIsEffectEnabled
				Debug.SetGodMode(False)
			EndIf
			moaBleedoutHandlerState.SetValue(0)
			LowHealthImod.Remove()
			PlayerRef.KillEssential(None)
			GoToState("")
		ElseIf ( ConfigMenu.iNotTradingAftermath == 1)
			Game.DisablePlayerControls()
			Debug.SetGodMode(True)
			If ConfigMenu.bIsEffectEnabled
				PlayerRef.DispelSpell(BleedoutProtection)
			EndIf
            If ConfigMenu.bShiftBackRespawn
                ShiftBack()
            EndIf
			If !bIsPlayerRagdoll
				PlayerRef.SetActorValue("Paralysis",1)
				PlayerRef.PushActorAway(PlayerRef,0)
			EndIf
			Utility.Wait(1.0)
			FadeOut.Apply()
			Utility.Wait(2.5)
			FadeOut.PopTo(BlackScreen)
			iRemovableItems = ConfigMenu.iRemovableItems
            If bInBeastForm()
                iRemovableItems = 0
            EndIf
			If ( iRemovableItems == 9 ) ;random
				iRemovableItems = Utility.RandomInt(0,5)
			ElseIf ( iRemovableItems == 8 ) ; Random but not everything or nothing
				iRemovableItems = Utility.RandomInt(1,4)
			ElseIf ( iRemovableItems == 7 ) ;Random but lose something
				iRemovableItems = Utility.RandomInt(1,5)
			Elseif ( iRemovableItems == 6 ) ;Random but not everything
				iRemovableItems = Utility.RandomInt(0,4)
			EndIf
			If  ConfigMenu.bLoseForever && (iRemovableItems != 0)
				If ( ( LostItemsChest.GetNumItems() > 0 ) || ( fLostSouls > 0.0 ) )
					bDidItemsRemoved = True
					If iDestroyedItems < 99999999
						iDestroyedItems += LostItemsChest.GetNumItems()
						If fLostSouls > 0.0
							iDestroyedItems += 1
						EndIf
					EndIf
				Else
					bDidItemsRemoved = False
				EndIf
				LostItemsChest.RemoveAllItems()
				fLostSouls = 0.0
			EndIf
			If iRemovableItems != 0
				Equipment = New Form[31]
				If iRemovableItems == 1
					RemoveTradbleItems(PlayerRef)
				Elseif iRemovableItems == 2
					RemoveTradbleItems(PlayerRef)
					RemoveUnequippedItems(PlayerRef)
				Elseif iRemovableItems == 3 ; unequipped but not tradables
					iSeptimCount = PlayerRef.GetItemCount(Gold001)
					iArkayMarkCount = PlayerRef.GetItemCount(MarkOfArkay) 
					iBSoulGemCount = PlayerRef.GetItemCount(BlackFilledGem)
					iGSoulGemCount = PlayerRef.GetItemCount(GrandFilledGem)
					fDragonSoulCount = PlayerRef.GetActorValue("DragonSouls")
					RemoveUnequippedItems(PlayerRef)
					If ( iSeptimCount > 0 ) && ConfigMenu.bIsGoldEnabled
						LostItemsChest.RemoveItem(Gold001, iSeptimCount, True, PlayerRef)
					EndIf
					If ( iBSoulGemCount > 0 ) && ConfigMenu.bIsBSoulGemEnabled
						LostItemsChest.RemoveItem(BlackFilledGem, iBSoulGemCount, True, PlayerRef)
					EndIf
					If ( iGSoulGemCount > 0 ) && ConfigMenu.bIsGSoulGemEnabled
						LostItemsChest.RemoveItem(GrandFilledGem, iGSoulGemCount, True, PlayerRef)
					EndIf
					If ( iArkayMarkCount > 0 ) && ConfigMenu.bIsMarkEnabled
						LostItemsChest.RemoveItem(MarkOfArkay, iArkayMarkCount, True, PlayerRef)
					EndIf
					If ( fDragonSoulCount > 0 ) && !ConfigMenu.bIsDragonSoulEnabled
						PlayerRef.ModActorValue("DragonSouls", -fDragonSoulCount)
						fLostSouls += fDragonSoulCount
					EndIf
				Elseif iRemovableItems == 4  ; Everything except tradables
					iSeptimCount = PlayerRef.GetItemCount(Gold001)
					iArkayMarkCount = PlayerRef.GetItemCount(MarkOfArkay) 
					iBSoulGemCount = PlayerRef.GetItemCount(BlackFilledGem)
					iGSoulGemCount = PlayerRef.GetItemCount(GrandFilledGem)
					fDragonSoulCount = PlayerRef.GetActorValue("DragonSouls")
					PlayerRef.RemoveAllItems(LostItemsChest, True)
					If ( iSeptimCount > 0 ) && ConfigMenu.bIsGoldEnabled
						LostItemsChest.RemoveItem(Gold001, iSeptimCount, True, PlayerRef)
					EndIf
					If ( iBSoulGemCount > 0 ) && ConfigMenu.bIsBSoulGemEnabled
						LostItemsChest.RemoveItem(BlackFilledGem, iBSoulGemCount, True, PlayerRef)
					EndIf
					If ( iGSoulGemCount > 0 ) && ConfigMenu.bIsGSoulGemEnabled
						LostItemsChest.RemoveItem(GrandFilledGem, iGSoulGemCount, True, PlayerRef)
					EndIf
					If ( iArkayMarkCount > 0 ) && ConfigMenu.bIsMarkEnabled
						LostItemsChest.RemoveItem(MarkOfArkay, iArkayMarkCount, True, PlayerRef)
					EndIf
					If ( fDragonSoulCount > 0 ) && !ConfigMenu.bIsDragonSoulEnabled
						PlayerRef.ModActorValue("DragonSouls", -fDragonSoulCount)
						fLostSouls += fDragonSoulCount
					EndIf
				Elseif iRemovableItems == 5
					RemoveTradbleItems(PlayerRef)
					PlayerRef.RemoveAllItems(LostItemsChest, True)
				Elseif iRemovableItems == 10
					RemoveValuableItems(PlayerRef)
				Elseif iRemovableItems == 11
					RemoveValuableItemsGreedy(PlayerRef)
				EndIf
				If ( ConfigMenu.iRemovableItems == 7 ) ;Remove All if nothing is removed
					If (( LostItemsChest.GetNumItems() == 0 ) && ( fLostSouls == 0 ) && ( iRemovableItems != 5 ))
						PlayerRef.RemoveAllItems(LostItemsChest, True)
					EndIf
				EndIf
				bIsItemsRemoved = True 
			EndIf
			If (( iRemovableItems != 0 ) || ( bIsItemsRemoved )) || ConfigMenu.bArkayCurse
				If (( LostItemsChest.GetNumItems() > 0 ) || ( fLostSouls > 0.0 )) || ConfigMenu.bArkayCurse
					LostItemsMarker.Enable()
					If !ConfigMenu.bSoulMarkStay || LostItemsMarker.GetParentCell() == DefaultCell					
						LostItemsMarker.MoveTo( PlayerRef, 0, 0, 42 )
					EndIf
				Else
					LostItemsMarker.MoveToMyEditorLocation()
					LostItemsMarker.Disable()
				EndIf
				Utility.Wait(0.1)
			EndIf
			PlayerRef.ResetHealthAndLimbs()
			PlayerRef.SetActorValue("Paralysis",0)
			PlayerRef.StopCombatAlarm()
			Utility.Wait(1.0)
			Game.ForceThirdPerson()
			If ( ConfigMenu.bSendToJail && bGuardCanSendToJail() && !bInBeastForm() )
				If ( Attacker.GetCrimeFaction() == CrimeFactionPale )
					PlayerRef.MoveTo(DawnstarJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionFalkreath )
					PlayerRef.MoveTo(FalkreathJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionHjaalmarch )
					PlayerRef.MoveTo(MorthalJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionHaafingar )
					PlayerRef.MoveTo(SolitudeJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionRift )
					PlayerRef.MoveTo(RiftenJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionWhiterun )
					PlayerRef.MoveTo(WhiterunJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionEastmarch )
					PlayerRef.MoveTo(WindhelmJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionWinterhold )
					PlayerRef.MoveTo(WinterholdJailMarker)
				ElseIf ( Attacker.GetCrimeFaction() == CrimeFactionReach )
					PlayerRef.MoveTo(MarkarthJailMarker)
					bCidhnaJail = True
				ElseIf ( Attacker.GetCrimeFaction() == DLC2CrimeRavenRockFaction )
					PlayerRef.MoveTo(DLC2RavenRockJailMarker)
				EndIf
				Utility.Wait(0.5)
				Attacker.GetCrimeFaction().SendPlayerToJail( abRemoveInventory = True, abRealJail = True )
			Else
				Teleport()
			EndIf
			Utility.Wait(0.5)
			Attacker = None
			RequipSpells()
			If PlayerRef.IsWeaponDrawn() ;If Player has a weapon drawn,
				PlayerRef.SheatheWeapon() ;Sheathe the drawn weapon.
			EndIf
			RefreshFace()
			PlayerRef.DispelAllSpells()
			Utility.Wait(6.0)			
			If ( ConfigMenu.bRespawnNaked && !bInBeastForm() )
				PlayerRef.UnequipAll()
			EndIf
			If ConfigMenu.bArkayCurse
			    If ConfigMenu.iArkayCurse == 0
					PlayerRef.AddSpell(ArkayCurse)
				ElseIf ConfigMenu.iArkayCurse == 1
					PlayerRef.AddSpell(ArkayCurseAlt)
				Else
					PlayerRef.AddSpell(ArkayCurse)
					PlayerRef.AddSpell(ArkayCurseAlt)
				EndIf
			EndIf
			BlackScreen.PopTo(FadeIn)
			Debug.SetGodMode(False)
			Game.EnablePlayerControls()
			Game.EnableFastTravel(True)
			PlayerRef.StopCombatAlarm()
			moaBleedoutHandlerState.SetValue(0)
			LowHealthImod.Remove()
			If bCidhnaJail 
				If ( PlayerRef.GetParentCell() == MarkarthJailMarker.GetParentCell() )
					If CidhnaMineJailEventScene.GetStageDone(10) == 0
						CidhnaMineJailEventScene.SetStage(10)
					EndIf
				EndIf
				bCidhnaJail = False
			EndIf
			If ( ConfigMenu.bLostItemQuest && ( ( iRemovableItems != 0 ) || PlayerRef.HasSpell(ArkayCurse) || PlayerRef.HasSpell(ArkayCurseAlt) ) )
				If ( ConfigMenu.bLoseForever && moaRetrieveLostItems.IsRunning() && bDidItemsRemoved )
					moaRetrieveLostItems.SetStage(10)
					Utility.Wait(0.5)
				EndIf
				If  ( ( LostItemsChest.GetNumItems() > 0 ) || ( fLostSouls > 0.0 ) || ConfigMenu.bArkayCurse )
					moaRetrieveLostItems.Start()
					moaRetrieveLostItems.SetStage(1)
				EndIf
			EndIf
			If iTotalRespawn < 99999999
				iTotalRespawn += 1
			EndIf
			GoToState("")
		Else
			Debug.SetGodMode(False)
			Game.EnablePlayerControls()
			Game.EnableFastTravel(True)
			moaBleedoutHandlerState.SetValue(0)
			LowHealthImod.Remove()
			GoToState("")
			Game.QuitToMainMenu()
		EndIf
	EndIf
EndFunction

Function RequipSpells() ; after entering bleedou while fighting with spell the game unequips spells and equip none as an item re-equiping spells usually that
		If ( LeftHandEquippedItem As Spell ) != None
			PlayerRef.UnequipSpell((LeftHandEquippedItem as spell), 0)
			PlayerRef.EquipSpell((LeftHandEquippedItem as spell), 0)
		EndIf
		If ( RightHandEquipedItem As Spell ) != None
			PlayerRef.UnequipSpell((RightHandEquipedItem as spell), 1)
			PlayerRef.EquipSpell((RightHandEquipedItem as spell), 1)
		EndIf
EndFunction

Function SetVars()
	iSeptimCount = PlayerRef.GetItemCount(Gold001)
	fDragonSoulCount = PlayerRef.GetActorValue("DragonSouls")
	iArkayMarkCount = PlayerRef.GetItemCount(MarkOfArkay) 
	iBSoulGemCount = PlayerRef.GetItemCount(BlackFilledGem)
	iGSoulGemCount = PlayerRef.GetItemCount(GrandFilledGem)
	bSeptimRevive = ((iSeptimCount >= ConfigMenu.fValueGoldSlider ) && ConfigMenu.bIsGoldEnabled)
	bDragonSoulRevive = ((fDragonSoulCount >= ConfigMenu.fValueSoulSlider) && ConfigMenu.bIsDragonSoulEnabled)
	bBSoulGemRevive = ((iBSoulGemCount >= ConfigMenu.fValueBSoulGemSlider) && ConfigMenu.bIsBSoulGemEnabled) 
	bGSoulGemRevive = ((iGSoulGemCount >= ConfigMenu.fValueGSoulGemSlider) && ConfigMenu.bIsGSoulGemEnabled) 
	bArkayMarkRevive = ((iArkayMarkCount >= ConfigMenu.fValueMarkSlider) && ConfigMenu.bIsMarkEnabled)
	bPotionRevive = ConfigMenu.bIsPotionEnabled
	If VItemArr.Length != 20
		VItemArr = new Form[20]
	EndIf
	If (bArkayMarkRevive)
		moaArkayMarkRevive.SetValue(1)
	Else
		moaArkayMarkRevive.SetValue(0)
	EndIf
	
	If (bDragonSoulRevive)
		moaDragonSoulRevive.SetValue(1)
	Else
		moaDragonSoulRevive.SetValue(0)
	EndIf
	
	If (bBSoulGemRevive)
		moaBSoulGemRevive.SetValue(1)
	Else
		moaBSoulGemRevive.SetValue(0)
	EndIf
	
	If (bGSoulGemRevive)
		moaGSoulGemRevive.SetValue(1)
	Else
		moaGSoulGemRevive.SetValue(0)
	EndIf
	
	If (bSeptimRevive)
		moaSeptimRevive.SetValue(1)
	Else
		moaSeptimRevive.SetValue(0)
	EndIf
	
	If (!PlayerRef.IsBleedingOut() && GetState() == "")
		LeftHandEquippedItem = PlayerRef.GetEquippedObject(0)
		RightHandEquipedItem = PlayerRef.GetEquippedObject(1)
	EndIf
EndFunction

Function SetGameVars()
	If (moaState.GetValue() == 1 )
		ConfigMenu.ToggleFallDamage(ConfigMenu.bIsNoFallDamageEnabled) ;SKSE
	Else
		ConfigMenu.ToggleFallDamage(False)
	EndIf
EndFunction

Bool Function bIsRevivable() ;if player can be revived by trading
	If ( bArkayMarkRevive || bBSoulGemRevive || bGSoulGemRevive || bDragonSoulRevive || bSeptimRevive )
		If ConfigMenu.bIsRevivalRequiresBlessing
			If ( PlayerRef.HasMagicEffect(FortifyHealthFFSelf) || bIsEquipedFromFormlist(ArkayAmulets) );player has magiceffect from a shrine of arkay or wearing one of 2 amulets of arkay
				Return True
			Else
				Return False
			EndIf
		Else
			Return True
		EndIf
	Else
		Return False
	EndIf
EndFunction

Bool Function bIsEquipedFromFormlist(FormList ItemList)
	Int iIndex = ItemList.GetSize()
	While iIndex > 0
		iIndex -= 1
		If PlayerRef.IsEquipped(ItemList.GetAt(iIndex))
			Return True
		EndIf
	EndWhile
	Return False
EndFunction

Int Function iGetRandomWithExclusion( Int iFrom, Int iTo, Int iExclude)
	If ( iExclude > iTo ) || ( iExclude < iFrom )
		Return Utility.RandomInt(iFrom, iTo)
	EndIf
	Int iRandom = Utility.RandomInt(iFrom, iTo - 1)
	If iRandom >= iExclude
		iRandom += 1
	EndIf
	Return iRandom
EndFunction

Int Function iGetRandomWithExclusionArray( Int iFrom, Int iTo, Bool[] iFlagArray) 
	Int ExcludeCount = 0
	int iIndex = 0
	Int iRandom = 0
	While iIndex < iFlagArray.Length
		If (!iFlagArray[iIndex] || bIsCurrentCell(iIndex))
			ExcludeCount += 1
		EndIf
		iIndex += 1
	Endwhile
	iRandom = Utility.RandomInt(iFrom, iTo - ExcludeCount)
	 iIndex = 0 
	 While (iIndex < iFlagArray.Length)
		If ( iRandom < iIndex )
			Return iRandom
		ElseIf (( iRandom >= iIndex ) && (!iFlagArray[iIndex] || bIsCurrentCell(iIndex) ))
			iRandom += 1
		EndIf
		iIndex += 1
	EndWhile
	Return iRandom
EndFunction

Function Teleport()
	PlayerMarker.Enable()
	PlayerMarker.MoveTo(playerRef)
	If (ConfigMenu.iTeleportLocation < (ConfigMenu.sRespawnPoints.Length - 5))
		If (PlayerRef.GetDistance(MarkerList.GetAt(ConfigMenu.iTeleportLocation) As Objectreference) >= 3000.0)
			PlayerRef.MoveTo( MarkerList.GetAt( ConfigMenu.iTeleportLocation ) As Objectreference, abMatchRotation = true)
			If !bIsArrived(MarkerList.GetAt(ConfigMenu.iTeleportLocation) As Objectreference)
				SendToAnotherLocation()
			EndIf 
		Else
			 SendToAnotherLocation()
		EndIf
	ElseIf (ConfigMenu.iTeleportLocation == (ConfigMenu.sRespawnPoints.Length - 5))
		RandomTeleport()
	ElseIf (ConfigMenu.iTeleportLocation == (ConfigMenu.sRespawnPoints.Length - 4))
		If ( bCanTeleportToDynMarker(SleepMarker) && (PlayerRef.GetDistance(SleepMarker) >= 3000.0))
			PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
			If !bIsArrived(SleepMarker)
				If ( bCanTeleportToDynMarker(CustomMarker) && ( CustomMarker.GetDistance(PlayerMarker) >= 3000.0 ) )
					PlayerRef.MoveTo(CustomMarker, abMatchRotation = true)
					If !bIsArrived(CustomMarker)
						SendToAnotherLocation()
					EndIf
				Else
					SendToAnotherLocation()
				EndIf
			EndIf
		ElseIf ((PlayerRef.GetDistance(CustomMarker) >= 3000.0 ) && bCanTeleportToDynMarker(CustomMarker) )
			PlayerRef.MoveTo(CustomMarker, abMatchRotation = true)
			If !bIsArrived(CustomMarker)
				SendToAnotherLocation()
			EndIf	
		Else
			 SendToAnotherLocation()
		EndIf
	ElseIf (ConfigMenu.iTeleportLocation == (ConfigMenu.sRespawnPoints.Length - 3))
		If ((PlayerRef.GetDistance(CustomMarker) >= 3000.0) && bCanTeleportToDynMarker(CustomMarker))
			PlayerRef.MoveTo(CustomMarker, abMatchRotation = true)
			If !bIsArrived(CustomMarker)
				If (bCanTeleportToDynMarker(SleepMarker) && ( SleepMarker.GetDistance(PlayerMarker) >= 3000.0 ))
					PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
					If !bIsArrived(SleepMarker)
						SendToAnotherLocation()
					EndIf
				Else
					SendToAnotherLocation()
				EndIf
			EndIf
		ElseIf (bCanTeleportToDynMarker(SleepMarker) && (PlayerRef.GetDistance(SleepMarker) >= 3000.0))
			PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
			If !bIsArrived(SleepMarker)
				SendToAnotherLocation()
			EndIf
		Else
			 SendToAnotherLocation()
		EndIf
	ElseIf (ConfigMenu.iTeleportLocation == (ConfigMenu.sRespawnPoints.Length - 2))
		If ExternalMarkerList.GetSize() > 0
			If ( ExternalMarkerList.GetSize() > 1 ) && ( ConfigMenu.iExternalIndex == -1 || ( ConfigMenu.iExternalIndex >= ExternalMarkerList.GetSize() ) || ( !bCanTeleportToExtMarker( ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ) As ObjectReference ) || (PlayerRef.GetDistance(ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ) As ObjectReference) < 3000.0) || ( ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ).GetType() != 61 ) ) )
				Int iMarkerIndex = iGetRandomRefFromListWithExclusions( 0, ExternalMarkerList.GetSize() - 1, ExternalMarkerList )
				If iMarkerIndex != -1
					PlayerRef.MoveTo( ExternalMarkerList.GetAt(iMarkerIndex) As ObjectReference, abMatchRotation = true )
					If !bIsArrived(ExternalMarkerList.GetAt( iMarkerIndex ) As ObjectReference)
						If ((PlayerMarker.GetDistance(CustomMarker) >= 3000.0) && bCanTeleportToDynMarker(CustomMarker))
							PlayerRef.MoveTo(CustomMarker, abMatchRotation = true)
							If !bIsArrived(CustomMarker)
								If (bCanTeleportToDynMarker(SleepMarker) && (PlayerMarker.GetDistance(SleepMarker) >= 3000.0))
									PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
									If !bIsArrived(SleepMarker)
										SendToAnotherLocation()
									EndIf
								Else
									SendToAnotherLocation()
								EndIf
							EndIf
						ElseIf (bCanTeleportToDynMarker(SleepMarker) && (PlayerMarker.GetDistance(SleepMarker) >= 3000.0))
							PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
							If !bIsArrived(SleepMarker)
								SendToAnotherLocation()
							EndIf
						Else
							SendToAnotherLocation()
						EndIf
					EndIf
				ElseIf ((PlayerRef.GetDistance(CustomMarker) >= 3000.0 ) && bCanTeleportToDynMarker(CustomMarker))
					PlayerRef.MoveTo( CustomMarker, abMatchRotation = true )
					If !bIsArrived(CustomMarker)
						If (bCanTeleportToDynMarker(SleepMarker) && (PlayerMarker.GetDistance(SleepMarker) >= 3000.0))
							PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
							If !bIsArrived(SleepMarker)
								SendToAnotherLocation()
							EndIf
						Else
							SendToAnotherLocation()
						EndIf
					EndIf
				ElseIf (bCanTeleportToDynMarker(SleepMarker) && (PlayerRef.GetDistance(SleepMarker) >= 3000.0))
					PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
					If !bIsArrived(SleepMarker)
						SendToAnotherLocation()
					EndIf
				Else
					SendToAnotherLocation()
				EndIf
			ElseIf ( bCanTeleportToExtMarker( ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ) As ObjectReference ) &&  (PlayerRef.GetDistance(ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ) As ObjectReference) >= 3000.0) && ( ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ).GetType() == 61 ) )
				PlayerRef.MoveTo( ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ) As ObjectReference, abMatchRotation = true )
				If !bIsArrived(ExternalMarkerList.GetAt( ConfigMenu.iExternalIndex ) As ObjectReference)
					If ((PlayerRef.GetDistance(CustomMarker) >= 3000.0) && bCanTeleportToDynMarker(CustomMarker))
						PlayerRef.MoveTo(CustomMarker, abMatchRotation = true)
						If !bIsArrived(CustomMarker)
							If (bCanTeleportToDynMarker(SleepMarker) && (PlayerMarker.GetDistance(SleepMarker) >= 3000.0))
								PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
								If !bIsArrived(SleepMarker)
									SendToAnotherLocation()
								EndIf
							Else
								SendToAnotherLocation()
							EndIf
						EndIf
					ElseIf (bCanTeleportToDynMarker(SleepMarker) && (PlayerMarker.GetDistance(SleepMarker) >= 3000.0))
						PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
						If !bIsArrived(SleepMarker)
							SendToAnotherLocation()
						EndIf
					Else
						SendToAnotherLocation()
					EndIf
				EndIf
			ElseIf ((PlayerRef.GetDistance(CustomMarker) >= 3000.0) && bCanTeleportToDynMarker(CustomMarker))
				PlayerRef.MoveTo( CustomMarker, abMatchRotation = true )
				If !bIsArrived(CustomMarker)
					If (bCanTeleportToDynMarker(SleepMarker) && (PlayerMarker.GetDistance(SleepMarker) >= 3000.0))
						PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
						If !bIsArrived(SleepMarker)
							SendToAnotherLocation()
						EndIf
					Else
						SendToAnotherLocation()
					EndIf
				EndIf
			ElseIf (bCanTeleportToDynMarker(SleepMarker) && (PlayerRef.GetDistance(SleepMarker) >= 3000.0))
				PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
				If !bIsArrived(SleepMarker)
					SendToAnotherLocation()
				EndIf
			Else
				SendToAnotherLocation()
			EndIf
		ElseIf ((PlayerRef.GetDistance(CustomMarker) >= 3000.0) && bCanTeleportToDynMarker(CustomMarker))
			PlayerRef.MoveTo( CustomMarker, abMatchRotation = true )
			If !bIsArrived(CustomMarker)
				If (bCanTeleportToDynMarker(SleepMarker) && (PlayerMarker.GetDistance(SleepMarker) >= 3000.0))
					PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
					If !bIsArrived(SleepMarker)
						SendToAnotherLocation()
					EndIf
				Else
					SendToAnotherLocation()
				EndIf
			EndIf
		ElseIf (bCanTeleportToDynMarker(SleepMarker)&& (PlayerRef.GetDistance(SleepMarker) >= 3000.0))
			PlayerRef.MoveTo(SleepMarker, abMatchRotation = true)
			If !bIsArrived(SleepMarker)
				SendToAnotherLocation()
			EndIf
		Else
			SendToAnotherLocation()
		EndIf
	Else
		SendToNearestLocation()
	EndIf
	PlayerMarker.MoveToMyEditorLocation()
	PlayerMarker.Disable()
EndFunction

Bool Function bIsCurrentCell(int iIndex)
	Return ((( MarkerList.GetAt(iIndex))  As Objectreference ).GetParentCell() == PlayerMarker.GetParentCell() )
EndFunction

Function RemoveTradbleItems (Actor ActorRef)
	If ( ActorRef.GetItemCount(Gold001) > 0 ) && ConfigMenu.bIsGoldEnabled
		ActorRef.RemoveItem(Gold001, ActorRef.GetItemCount(Gold001), True, LostItemsChest)
	EndIf
	If( ActorRef.GetItemCount(MarkOfArkay) > 0 ) && ConfigMenu.bIsMarkEnabled
		ActorRef.RemoveItem(MarkOfArkay, ActorRef.GetItemCount(MarkOfArkay), True, LostItemsChest)
	EndIf
	If ( ActorRef.GetItemCount(BlackFilledGem) > 0 ) && ConfigMenu.bIsBSoulGemEnabled
		ActorRef.RemoveItem(BlackFilledGem, ActorRef.GetItemCount(BlackFilledGem), True, LostItemsChest)
	EndIf
	If ( ActorRef.GetItemCount(GrandFilledGem) > 0 ) && ConfigMenu.bIsGSoulGemEnabled
		ActorRef.RemoveItem(GrandFilledGem, ActorRef.GetItemCount(GrandFilledGem), True, LostItemsChest)
	EndIf
	If ( ActorRef.GetActorValue("DragonSouls") > 0 ) && ConfigMenu.bIsDragonSoulEnabled
		fLostSouls += ActorRef.GetActorValue("DragonSouls")
		PlayerRef.ModActorValue("DragonSouls", -PlayerRef.GetActorValue("DragonSouls"))
	EndIf
EndFunction

Function RemoveUnequippedItems(Actor ActorRef)
	Bool LeftHand = False
	Bool RightHand = False
	If RightHandEquipedItem && !(RightHandEquipedItem As Spell) 
		ActorRef.RemoveItem(RightHandEquipedItem, 1, True, EquippedItemsChest)
		RightHand = True
	EndIf
	If LeftHandEquippedItem && !(LeftHandEquippedItem As Spell) && !( LeftHandEquippedItem == RightHandEquipedItem )
		ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, EquippedItemsChest)
		LeftHand = True
	EndIf
	Int i = 30
	While i < 61
		ActorRef.unequipItemSlot(i)
		i += 1
	EndWhile
	Utility.Wait(0.2)
	ActorRef.RemoveAllItems(LostItemsChest, True)
	EquippedItemsChest.RemoveAllItems(ActorRef, True, True)
	If !ConfigMenu.bRespawnNaked
		If RightHand 
			If	ActorRef.GetItemCount(RightHandEquipedItem) > 0
				ActorRef.EquipItem(RightHandEquipedItem, False, True)
				Utility.Wait(0.2)
			EndIf
		ElseIf LeftHand && !(RightHandEquipedItem As Spell)
			If	ActorRef.GetItemCount(LeftHandEquippedItem) > 0
				ActorRef.EquipItem(LeftHandEquippedItem, False, True)
				Utility.Wait(0.2)
			EndIf
		EndIf
		;If LeftHand
		;	ActorRef.EquipItemEx(LeftHandEquippedItem,2,False,True) ;CTD?
		;	Utility.Wait(0.2)
		;EndIf
		i = Equipment.length
		While i > 0
			i -= 1
			If Equipment[i] As Armor
				If ActorRef.GetItemCount(Equipment[i]) > 0
					ActorRef.EquipItem(Equipment[i],False, True)
					Utility.Wait(0.2)
				EndIf
			EndIf
		EndWhile
	EndIf
EndFunction

Function RestoreLostItems(Actor ActorRef)
	If bIsItemsRemoved
		LostItemsMarker.MoveToMyEditorLocation()
		LostItemsMarker.Disable()
		LostItemsChest.RemoveAllItems(ActorRef, True, True)
		If fLostSouls > 0.0
			ActorRef.ModActorValue("DragonSouls", fLostSouls)
			fLostSouls = 0.0
		EndIf
		bIsItemsRemoved = False
		If ConfigMenu.bIsNotificationEnabled
			Debug.Notification("$mrt_MarkofArkay_Notification_RestoreLostItems")
		EndIf
	EndIf
	ActorRef.RemoveSpell(ArkayCurse)
	ActorRef.RemoveSpell(ArkayCurseAlt)
EndFunction

Function RefreshFace()	;for closed eye bug
	; Disabling facegen
	bool oldUseFaceGen = Utility.GetINIBool( "bUseFaceGenPreprocessedHeads:General" )
	if ( oldUseFaceGen )
		Utility.SetINIBool( "bUseFaceGenPreprocessedHeads:General", false )
	endif
	
	; Updating player
	PlayerRef.QueueNiNodeUpdate()
	
	; Restoring facegen
	if ( oldUseFaceGen )
		Utility.SetINIBool( "bUseFaceGenPreprocessedHeads:General", true )
	endif
EndFunction

Bool Function IsInInteriorActual(ObjectReference akObjectReference)
    If akObjectReference.IsInInterior()
	    Return True
	EndIf
    If WorldspacesInterior.HasForm(akObjectReference.GetWorldSpace())
		Return True
	EndIf
	Return False
EndFunction

Bool Function bCanTeleport()
	Int iIndex = QuestBlackList.GetSize()
	While iIndex > 0
		iIndex -= 1
		If (QuestBlackList.GetAt(iIndex) As Quest).IsRunning()
			Return False
		EndIf
	EndWhile
	iIndex = LocationBlackList.GetSize()
	While iIndex > 0
		iIndex -= 1
		If PlayerRef.IsInLocation(LocationBlackList.GetAt(iIndex) As Location)
			Return False
		EndIf
	EndWhile
	Return True
EndFunction

Bool Function bCanTeleportToExtMarker( Objectreference ExternalMarker )
	If ExternalMarker
		Int iIndex = LocationBlackList.GetSize()
		While iIndex > 0
			iIndex -= 1
			If ExternalMarker.IsInLocation(LocationBlackList.GetAt(iIndex) As Location)
				Return False
			EndIf
		EndWhile
		If ( !ExternalMarker.IsDisabled() && ( ExternalMarker.GetParentCell() != DefaultCell ) )
			Return True
		EndIf
	EndIf
	Return False
EndFunction

Bool Function bCanTeleportToDynMarker(Objectreference Marker)
	If Marker
		Int iIndex = LocationBlackList.GetSize()
		While iIndex > 0
			iIndex -= 1
			If Marker.IsInLocation(LocationBlackList.GetAt(iIndex) As Location)
				Return False
			EndIf
		EndWhile 
		If !Marker.IsDisabled()
			If ( Marker.GetParentCell() != DefaultCell )
				Return True
			EndIf
		EndIf
	EndIf
	Return False
EndFunction

Int Function iGetRandomRefFromListWithExclusions( Int iFrom, Int iTo, Formlist RefList) 
	Int ExcludeCount = 0
	int iIndex = 0
	Int iRandom = 0
	ObjectReference MarkerRef
	While iIndex < RefList.GetSize()
		If RefList.GetAt(iIndex).GetType() != 61
			ExcludeCount += 1
		Else
			MarkerRef = ( RefList.GetAt(iIndex) As ObjectReference )
			If ( !bCanTeleportToExtMarker( MarkerRef ) || BIsRefInCurrentCell( MarkerRef ) )
				ExcludeCount += 1
			EndIf
		EndIf
		iIndex += 1
	Endwhile
	If ( ExcludeCount == RefList.GetSize() )
		Return -1
	EndIf
	iRandom = Utility.RandomInt(iFrom, iTo - ExcludeCount)
	 iIndex = 0 
	 While ( iIndex < RefList.GetSize() )
		MarkerRef = ( RefList.GetAt(iIndex) As ObjectReference )
		If ( iRandom < iIndex )
			Return iRandom
		ElseIf (( iRandom >= iIndex ) && ( ( RefList.GetAt(iIndex).GetType() != 61 ) || !bCanTeleportToExtMarker( MarkerRef ) || BIsRefInCurrentCell( MarkerRef ) ))
			iRandom += 1
		EndIf
		iIndex += 1
	EndWhile
	Return iRandom
EndFunction

Bool Function BIsRefInCurrentCell ( ObjectReference MarkerRef)
	Return (( MarkerRef ).GetParentCell() == PlayerRef.GetParentCell() )
EndFunction

Function RandomTeleport()
	PlayerRef.MoveTo( MarkerList.GetAt( iGetRandomWithExclusionArray( 0, (MarkerList.GetSize() - 1), ConfigMenu.bRespawnPointsFlags) ) As Objectreference, abMatchRotation = true )
EndFunction

Function SendToAnotherLocation()
	Int iIndex = LocationsList.GetSize()
	While ( iIndex > 0 )
		iIndex -= 1
		If ( iIndex == 4 )
			If ( bInSameLocation(LocationsList.GetAt(iIndex) As Location) || bInSameLocation(HjaalmarchHoldLocation) ) ;Solitude or Morthal
				If ConfigMenu.bRespawnPointsFlags[iIndex]
					If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0 )
						PlayerRef.MoveTo( MarkerList.GetAt(iIndex) As ObjectReference )
						If bIsArrived(MarkerList.GetAt(iIndex) As ObjectReference)
							Return
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf ( iIndex == 6 )
			If ( bInSameLocation(LocationsList.GetAt(iIndex) As Location) || bInSameLocation(PaleHoldLocation) ) ;Winterhold or Dawnstar
				If ConfigMenu.bRespawnPointsFlags[iIndex]
					If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0 )
						PlayerRef.MoveTo( MarkerList.GetAt(iIndex) As ObjectReference )
						If bIsArrived(MarkerList.GetAt(iIndex) As ObjectReference)
							Return
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf bInSameLocation(LocationsList.GetAt(iIndex) As Location)
			If ConfigMenu.bRespawnPointsFlags[iIndex]
				If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0 )
					PlayerRef.MoveTo( MarkerList.GetAt(iIndex) As ObjectReference )
					If bIsArrived(MarkerList.GetAt(iIndex) As ObjectReference)
						Return
					EndIf
				EndIf
			EndIf
		EndIf
	EndWhile
	RandomTeleport()
EndFunction

Function ShiftBack()
	float i = 5.0
	If (WerewolfQuest.IsRunning())
		PlayerRef.StopCombatAlarm()
		Debug.SetGodMode(True)
		PlayerRef.DispelSpell(BleedoutProtection)
		Game.DisablePlayerControls()
		WerewolfQuest.SetStage(100)
		While (PlayerRef.GetAnimationVariableBool("bIsSynced") && (i > 0.0))
			Utility.Wait(0.2)
			i -= 0.2
		EndWhile
		;Debug.SetGodMode(False)
		;Game.EnablePlayerControls()
	ElseIf(VampireLordQuest.IsRunning())
		PlayerRef.StopCombatAlarm()
		Debug.SetGodMode(True)
		PlayerRef.DispelSpell(BleedoutProtection)
		Game.DisablePlayerControls()
		VampireLordQuest.SetStage(100) ; shift back
		While (PlayerRef.GetAnimationVariableBool("bIsSynced") && (i > 0.0))
			Utility.Wait(0.2)
			i -= 0.2
		EndWhile
		;Debug.SetGodMode(False)
		;Game.EnablePlayerControls()
	EndIf
EndFunction

Int Function iHasHealingPotion()
		Int iPotionIndex = -1
		Bool bBreak = False
		Int iIndex = PotionList.GetSize()
		While ( ( iIndex > 0 ) && !bBreak )
			iIndex -= 1
			If PlayerRef.GetItemCount(PotionList.GetAt(iIndex) As Potion) > 0
				bBreak = True
				iPotionIndex = iIndex
			EndIf
		Endwhile
		Return iPotionIndex
EndFunction

Function RemoveValuableItems(Actor ActorRef)
	If ActorRef.GetItemCount(Gold001) > 499
		ActorRef.RemoveItem(Gold001, ActorRef.GetItemCount(Gold001), True, LostItemsChest)
		Return
	ElseIf ( ActorRef.GetActorValue("DragonSouls") > 0 ) && ConfigMenu.bIsDragonSoulEnabled
		fLostSouls += ActorRef.GetActorValue("DragonSouls")
		ActorRef.ModActorValue("DragonSouls", -ActorRef.GetActorValue("DragonSouls"))
		Return
	ElseIf( ActorRef.GetItemCount(MarkOfArkay) > 0 ) && ConfigMenu.bIsMarkEnabled
		ActorRef.RemoveItem(MarkOfArkay, ActorRef.GetItemCount(MarkOfArkay), True, LostItemsChest)
		Return
	ElseIf ( ActorRef.GetItemCount(BlackFilledGem) > 0 ) && ConfigMenu.bIsBSoulGemEnabled
		ActorRef.RemoveItem(BlackFilledGem, ActorRef.GetItemCount(BlackFilledGem), True, LostItemsChest)
		Return
	ElseIf ( ActorRef.GetItemCount(GrandFilledGem) > 0 ) && ConfigMenu.bIsGSoulGemEnabled
		ActorRef.RemoveItem(GrandFilledGem, ActorRef.GetItemCount(GrandFilledGem), True, LostItemsChest)
		Return
	EndIf
	Bool bValuable = False
	Bool LeftHand = False
	Bool RightHand = False
	Int iSum = 0
	If RightHandEquipedItem && !(RightHandEquipedItem As Spell) 
		ActorRef.RemoveItem(RightHandEquipedItem, 1, True, EquippedItemsChest)
		RightHand = True
	EndIf
	If LeftHandEquippedItem && !(LeftHandEquippedItem As Spell) && !( LeftHandEquippedItem == RightHandEquipedItem )
		ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, EquippedItemsChest)
		LeftHand = True
	EndIf
	Int itemIndex = 30
	While itemIndex < 61
		ActorRef.unequipItemSlot(itemIndex)
		itemIndex += 1
	EndWhile
	Utility.Wait(0.2)
	ValuableItemsChest.RemoveAllItems()
	ActorRef.RemoveAllItems(ValuableItemsChest, True)
	EquippedItemsChest.RemoveAllItems(ActorRef, True, True)
	Int iTotal = ValuableItemsChest.GetNumItems()
	If iTotal > 40
		iTotal = Utility.RandomInt(40, iTotal)
	EndIf
	Int iIndex = iTotal
	If iIndex != 0
		Form kForm
		Bool bBreak = False
		While ( iIndex > 0 ) && ( iTotal - iIndex ) < 40 && !bBreak
			iIndex -= 1
			If bIsTypeLegit( ValuableItemsChest.GetNthForm( iIndex )) 
				If	( ( !KForm ) || ( ( KForm.GetGoldValue() * ValuableItemsChest.GetItemCount(kForm) ) <  ( ValuableItemsChest.GetNthForm(iIndex).GetGoldValue() * ValuableItemsChest.GetItemCount( ValuableItemsChest.GetNthForm( iIndex )))))
					kForm = ValuableItemsChest.GetNthForm(iIndex)
					If KForm.GetGoldValue()  > 499
						bBreak = True
					EndIf
				EndIf
				If iSum < 500
					iSum = ( iSum + ( ValuableItemsChest.GetNthForm(iIndex).GetGoldValue() * ValuableItemsChest.GetItemCount( ValuableItemsChest.GetNthForm( iIndex ))))
				EndIf
			EndIf
		Endwhile
		Form VItem = kForm
		Form Ktemp
		Int iEmpty
		If KForm && ( VItemArr.Find(KForm) < 0 )
			iEmpty = VItemArr.Find(None)
			If iEmpty > -1
				VItemArr[iEmpty] = KForm
			Else
				iIndex = VItemArr.Length
				While iIndex > 0
					iIndex -= 1
					If ( KForm.GetGoldValue() * ValuableItemsChest.GetItemCount(KForm)) > ( VItemArr[iIndex].GetGoldValue() * ValuableItemsChest.GetItemCount( VItemArr[iIndex] ))
						Ktemp = VItemArr[iIndex]
						VItemArr[iIndex] = KForm
						KForm = Ktemp
					EndIf
				Endwhile
			EndIf
		EndIf
		iIndex = VItemArr.Length
		While iIndex > 0
			iIndex -= 1
			If VItemArr[iIndex]
				If ( !VItem ) || (( VItemArr[iIndex].GetGoldValue() * ValuableItemsChest.GetItemCount( VItemArr[iIndex] )) > ( VItem.GetGoldValue() * ValuableItemsChest.GetItemCount(VItem)))
					VItem = VItemArr[iIndex]
				EndIf
			EndIf
		EndWhile
		If ( bIsTypeLegit(VItem) && (( VItem.GetGoldValue() * ValuableItemsChest.GetItemCount(VItem) ) > 499 ))
			ValuableItemsChest.RemoveItem(VItem, ValuableItemsChest.GetItemCount(VItem), True, LostItemsChest )
			bValuable = True
		ElseIf (ValuableItemsChest.GetNumItems() > 40)
			Int iTotalOld = iTotal
			If ValuableItemsChest.GetNumItems() > 60
				iTotal = iGetRandomWithExclusion(60, ValuableItemsChest.GetNumItems(), iTotal)
			Else
				iTotal = ValuableItemsChest.GetNumItems()
			EndIf
			Bool bOverlap = False
			Int i = iTotal
			Int c = i
			If c <= iTotalOld
				If (( iTotalOld - c ) < 40)
					c = c - (40 - (iTotalOld - i))
					bOverlap = True
				EndIf
			EndIf
			bBreak = False
			While ( c > 0 ) && ( ( iTotal - i ) < 60 ) && !bValuable
				c -= 1
				i -= 1
				If bIsTypeLegit( ValuableItemsChest.GetNthForm( c ) )
					If ( ValuableItemsChest.GetNthForm( c ).GetGoldValue() * ValuableItemsChest.GetItemCount( ValuableItemsChest.GetNthForm( c ))) > 499																
						ValuableItemsChest.RemoveItem(ValuableItemsChest.GetNthForm(c), ValuableItemsChest.GetItemCount(ValuableItemsChest.GetNthForm(c)), True, LostItemsChest )
						bValuable = True
					ElseIf iSum < 500
						iSum = ( iSum + ( ValuableItemsChest.GetNthForm( c ).GetGoldValue() * ValuableItemsChest.GetItemCount( ValuableItemsChest.GetNthForm( c ))))
					EndIf
				EndIf
				If bOverlap
					If c == 0
						c = (iTotal + (60 - (iTotal - i)))
						If c > ValuableItemsChest.GetNumItems()
							c = ValuableItemsChest.GetNumItems()
						EndIf
					ElseIf (c == iTotal)
						c = 0
					EndIf
				ElseIf (c == iTotalOld)
					c -= 40
					bOverlap = True
					If c < 1
						c = (iTotal + (60 - (iTotal - i)))
						If c > ValuableItemsChest.GetNumItems()
							c = ValuableItemsChest.GetNumItems()
						EndIf
					EndIf
				EndIf
			Endwhile
		EndIf
		If !bValuable
			If iSum < 500
				If ValuableItemsChest.GetNumItems() > 100
					iSum = ( ( iSum * ValuableItemsChest.GetNumItems() ) / 100  )
				EndIf
			EndIf
			ValuableItemsChest.RemoveAllItems( LostItemsChest, True ) 
			If ( iSum < 500 )
				Int iItem = Equipment.Length
				While ( iItem > 0 ) && !bValuable
					iItem -= 1
					If Equipment[iItem]
						If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ActorRef.GetItemCount(Equipment[iItem]) > 0 && (( Equipment[iItem].GetGoldValue() + iSum ) > 499 ))
							ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
							bValuable = True
						EndIf
					EndIf
				EndWhile
				If !bValuable
					If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem) && ( ( LeftHandEquippedItem.GetGoldValue() + iSum ) > 499 )
						ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
					ElseIf RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem) && ( ( RightHandEquipedItem.GetGoldValue() + iSum ) > 499 )
						ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)
					Else
						iItem = Equipment.Length
						While (( iItem > 0 ) && ( iSum < 500 ))
							iItem -= 1
							If Equipment[iItem]
								If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ( ActorRef.GetItemCount(Equipment[iItem]) > 0 ))
									iSum = iSum + Equipment[iItem].GetGoldValue()
									ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
								EndIf
							EndIf
						EndWhile
						If iSum < 500
							If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem)
								iSum = iSum + LeftHandEquippedItem.GetGoldValue()
								ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
							EndIf
						EndIf
						If iSum < 500
							If RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem)
								ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		Utility.Wait(0.1)
		ValuableItemsChest.RemoveAllItems(ActorRef, True, True)
	Else
		Int iItem = Equipment.Length
		While ( iItem > 0 ) && !bValuable
			iItem -= 1
			If Equipment[iItem]
				If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ActorRef.GetItemCount(Equipment[iItem]) > 0 && ( Equipment[iItem].GetGoldValue() > 499 ))
					ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
					bValuable = True
				EndIf
			EndIf
		EndWhile
		If !bValuable
			If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem) && ( LeftHandEquippedItem.GetGoldValue() > 499 )
				ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
			ElseIf RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem) && ( RightHandEquipedItem.GetGoldValue() > 499 )
				ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)
			Else
				iItem = Equipment.Length
				While (( iItem > 0 ) && ( iSum < 500 ))
					iItem -= 1
					If Equipment[iItem]
						If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ( ActorRef.GetItemCount(Equipment[iItem]) > 0 ))
							iSum = iSum + Equipment[iItem].GetGoldValue()
							ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
						EndIf
					EndIf
				EndWhile
				If iSum < 500
					If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem)
						iSum = iSum + LeftHandEquippedItem.GetGoldValue()
						ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
					EndIf
				EndIf
				If iSum < 500
					If RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem)
						ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	Utility.Wait(0.1)
	If !ConfigMenu.bRespawnNaked
		If RightHand 
			If	ActorRef.GetItemCount(RightHandEquipedItem) > 0
				ActorRef.EquipItem(RightHandEquipedItem, False, True)
				Utility.Wait(0.2)
			EndIf
		ElseIf LeftHand && !(RightHandEquipedItem As Spell)
			If	ActorRef.GetItemCount(LeftHandEquippedItem) > 0
				ActorRef.EquipItem(LeftHandEquippedItem, False, True)
				Utility.Wait(0.2)
			EndIf
		EndIf
		;If LeftHand && ActorRef.GetItemCount(LeftHandEquippedItem) > 0
		;	ActorRef.EquipItemEx(LeftHandEquippedItem, 2, False, True)
		;	Utility.Wait(0.2)
		;EndIf
		itemIndex = Equipment.Length
		While itemIndex > 0
			itemIndex -= 1
			If Equipment[itemIndex] As Armor
				If ActorRef.GetItemCount(Equipment[itemIndex]) > 0
					ActorRef.EquipItem(Equipment[itemIndex],False, True)
					Utility.Wait(0.2)
				EndIf
			EndIf
		EndWhile
	EndIf
EndFunction

Function RemoveValuableItemsGreedy(Actor ActorRef)
	Bool bFound1 = False
	Bool bFound = False
	If ActorRef.GetItemCount(Gold001) > 0
		If ActorRef.GetItemCount(Gold001) > 499
			bFound1 = True
		EndIf
		ActorRef.RemoveItem(Gold001, ActorRef.GetItemCount(Gold001), True, LostItemsChest)
	EndIf
	If ( ActorRef.GetActorValue("DragonSouls") > 0 ) && ConfigMenu.bIsDragonSoulEnabled
		fLostSouls += ActorRef.GetActorValue("DragonSouls")
		ActorRef.ModActorValue("DragonSouls", -ActorRef.GetActorValue("DragonSouls"))
		bFound1 = True
	EndIf
	If( ActorRef.GetItemCount(MarkOfArkay) > 0 ) && ConfigMenu.bIsMarkEnabled
		ActorRef.RemoveItem(MarkOfArkay, ActorRef.GetItemCount(MarkOfArkay), True, LostItemsChest)
		bFound1 = True
	EndIf
	If ( ActorRef.GetItemCount(BlackFilledGem) > 0 ) && ConfigMenu.bIsBSoulGemEnabled
		ActorRef.RemoveItem(BlackFilledGem, ActorRef.GetItemCount(BlackFilledGem), True, LostItemsChest)
		bFound1 = True
	EndIf
	If ( ActorRef.GetItemCount(GrandFilledGem) > 0 ) && ConfigMenu.bIsGSoulGemEnabled
		ActorRef.RemoveItem(GrandFilledGem, ActorRef.GetItemCount(GrandFilledGem), True, LostItemsChest)
		bFound1 = True
	EndIf
	Bool LeftHand = False
	Bool RightHand = False
	If RightHandEquipedItem && !(RightHandEquipedItem As Spell) 
		ActorRef.RemoveItem(RightHandEquipedItem, 1, True, EquippedItemsChest)
		RightHand = True
	EndIf
	If LeftHandEquippedItem && !(LeftHandEquippedItem As Spell) && !( LeftHandEquippedItem == RightHandEquipedItem )
		ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, EquippedItemsChest)
		LeftHand = True
	EndIf
	Int itemIndex = 30
	While itemIndex < 61
		ActorRef.unequipItemSlot(itemIndex)
		itemIndex += 1
	EndWhile
	Utility.Wait(0.2)
	ValuableItemsChest.RemoveAllItems()
	ActorRef.RemoveAllItems(ValuableItemsChest, True)
	EquippedItemsChest.RemoveAllItems(ActorRef, True, True)
	Int iTotal = ValuableItemsChest.GetNumItems()
	If iTotal > 40
		iTotal = Utility.RandomInt(40, iTotal)
	EndIf
	Int iIndex = iTotal
	Int iSum = 0
	If iIndex != 0
		Form kForm
		Form VItem
		Int iEmpty
		Int iIndex1
		Form Ktemp
		iIndex1 = VItemArr.Length
		While iIndex1 > 0
			iIndex1 -= 1
			If VItemArr[iIndex1]
				If ( VItemArr[iIndex1].GetGoldValue() * ValuableItemsChest.GetItemCount( VItemArr[iIndex1] )) > 499
					bFound = True
					VItem = VItemArr[iIndex1] 
					ValuableItemsChest.RemoveItem(VItem, ValuableItemsChest.GetItemCount(VItem), True, LostItemsChest )	
				EndIf
			EndIf
		Endwhile
		While  ( iIndex > 0 ) && ( iTotal - iIndex ) < 40
			iIndex -= 1
			If  bIsTypeLegit( ValuableItemsChest.GetNthForm( iIndex )) 
				If ( ValuableItemsChest.GetNthForm(iIndex).GetGoldValue() * ValuableItemsChest.GetItemCount( ValuableItemsChest.GetNthForm( iIndex ))) > 499
					kForm = ValuableItemsChest.GetNthForm(iIndex)
					VItem = KForm
					bFound = True
					If ( VItemArr.Find(kForm) < 0 )
						iEmpty = VItemArr.Find(none)
						If iEmpty > -1
							VItemArr[iEmpty] = kForm
						Else
							iIndex1 = VItemArr.Length
							While iIndex1 > 0
								iIndex1 -= 1
								If ( kForm.GetGoldValue() * ValuableItemsChest.GetItemCount(kForm)) > ( VItemArr[iIndex1].GetGoldValue() * ValuableItemsChest.GetItemCount( VItemArr[iIndex1] ))
									Ktemp = VItemArr[iIndex1]
									VItemArr[iIndex1] = kForm
									kForm = Ktemp
								EndIf
							Endwhile
						EndIf
					EndIf
					ValuableItemsChest.RemoveItem(VItem, ValuableItemsChest.GetItemCount(VItem), True, LostItemsChest )
				ElseIf !bFound
					If iSum < 500
						iSum += (ValuableItemsChest.GetNthForm(iIndex).GetGoldValue() * ValuableItemsChest.GetItemCount(ValuableItemsChest.GetNthForm( iIndex ))) 
					EndIf
				EndIf
			EndIf
		Endwhile
		If !bFound
			If ( ValuableItemsChest.GetNumItems() > 40 )
				Int iTotalOld = iTotal
				If ValuableItemsChest.GetNumItems() > 60
					iTotal = iGetRandomWithExclusion(60, ValuableItemsChest.GetNumItems(), iTotal)
				Else
					iTotal = ValuableItemsChest.GetNumItems()
				EndIf
				Bool bOverlap = False
				Int i = iTotal
				Int c = i
				If c <= iTotalOld
					If (( iTotalOld - c ) < 40)
						c = c - (40 - (iTotalOld - i))
						bOverlap = True
					EndIf
				EndIf
				While ( c > 0 ) && ( ( iTotal - i ) < 60 )
					c -= 1
					i -= 1
					If bIsTypeLegit( ValuableItemsChest.GetNthForm(c))
						If ( ValuableItemsChest.GetNthForm(c).GetGoldValue() * ValuableItemsChest.GetItemCount( ValuableItemsChest.GetNthForm( c ))) > 499																	
							ValuableItemsChest.RemoveItem(ValuableItemsChest.GetNthForm(c), ValuableItemsChest.GetItemCount(ValuableItemsChest.GetNthForm(c)), True, LostItemsChest )
							bFound = True
						ElseIf !bFound
							If iSum < 500
								iSum += (ValuableItemsChest.GetNthForm(c).GetGoldValue() * ValuableItemsChest.GetItemCount(ValuableItemsChest.GetNthForm(c)))
							EndIf
						EndIf
					EndIf
					If bOverlap
						If c == 0
							c = (iTotal + (60 - (iTotal - i)))
							If c > ValuableItemsChest.GetNumItems()
								c = ValuableItemsChest.GetNumItems()
							EndIf
						ElseIf (c == iTotal)
							c = 0
						EndIf
					ElseIf (c == iTotalOld)
						c -= 40
						bOverlap = True
						If c < 1
							c = (iTotal + (60 - (iTotal - i)))
							If c > ValuableItemsChest.GetNumItems()
								c = ValuableItemsChest.GetNumItems()
							EndIf
						EndIf
					EndIf
				Endwhile
			EndIf
		EndIf
		If (!bFound && !bFound1)
			If ( iSum < 500 )
				If ValuableItemsChest.GetNumItems() > 100
					iSum = ((iSum * ValuableItemsChest.GetNumItems()) / 100)
				EndIf
			EndIf
			ValuableItemsChest.RemoveAllItems( LostItemsChest, True ) 
			If ( iSum < 500 )
				Int iItem = Equipment.Length
				While ( iItem > 0 ) && !bFound
					iItem -= 1
					If Equipment[iItem]
						If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ActorRef.GetItemCount(Equipment[iItem]) > 0 && ( ( Equipment[iItem].GetGoldValue() + iSum ) > 499 ))
							ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
							bFound = True
						EndIf
					EndIf
				EndWhile
				If !bFound
					If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem) && ( ( LeftHandEquippedItem.GetGoldValue() + iSum ) > 499 )
						ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
					ElseIf RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem) && ( ( RightHandEquipedItem.GetGoldValue() + iSum ) > 499 )
						ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)
					Else
						iItem = Equipment.Length
						While (( iItem > 0 ) && ( iSum < 500 ))
							iItem -= 1
							If Equipment[iItem]
								If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ( ActorRef.GetItemCount(Equipment[iItem]) > 0 ))
									iSum = iSum + Equipment[iItem].GetGoldValue()
									ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
								EndIf
							EndIf
						EndWhile
						If iSum < 500
							If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem)
								iSum = iSum + LeftHandEquippedItem.GetGoldValue()
								ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
							EndIf
						EndIf
						If iSum < 500
							If RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem)
								ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)								
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		Utility.Wait(0.1)
		ValuableItemsChest.RemoveAllItems(ActorRef, True, True)
	ElseIf !bFound1
		Int iItem = Equipment.Length
		While ( iItem > 0 ) && !bFound
			iItem -= 1
			If Equipment[iItem]
				If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ActorRef.GetItemCount(Equipment[iItem]) > 0 && ( Equipment[iItem].GetGoldValue() > 499 ))
					ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
					bFound = True
				EndIf
			EndIf
		EndWhile
		If !bFound
			If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem) && ( LeftHandEquippedItem.GetGoldValue() > 499 )
				ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
			ElseIf RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem) && ( RightHandEquipedItem.GetGoldValue() > 499 )
				ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)
			Else
				iItem = Equipment.Length
				While (( iItem > 0 ) && ( iSum < 500 ))
					iItem -= 1
					If Equipment[iItem]
						If ( Equipment[iItem] && bIsTypeLegit(Equipment[iItem]) && ( ActorRef.GetItemCount(Equipment[iItem]) > 0 ))
							iSum = iSum + Equipment[iItem].GetGoldValue()
							ActorRef.RemoveItem(Equipment[iItem], 1, True, LostItemsChest)
						EndIf
					EndIf
				EndWhile
				If iSum < 500
					If LeftHand && ( ActorRef.GetItemCount(LeftHandEquippedItem) > 0 ) && bIsTypeLegit(LeftHandEquippedItem)
						iSum = iSum + LeftHandEquippedItem.GetGoldValue()
						ActorRef.RemoveItem(LeftHandEquippedItem, 1, True, LostItemsChest)
					EndIf
				EndIf
				If iSum < 500
					If RightHand && ( ActorRef.GetItemCount(RightHandEquipedItem) > 0 ) && bIsTypeLegit(RightHandEquipedItem)
						ActorRef.RemoveItem(RightHandEquipedItem, 1, True, LostItemsChest)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	Utility.Wait(0.1)
	If !ConfigMenu.bRespawnNaked
		If RightHand 
			If	ActorRef.GetItemCount(RightHandEquipedItem) > 0
				ActorRef.EquipItem(RightHandEquipedItem, False, True)
				Utility.Wait(0.2)
			EndIf
		ElseIf LeftHand && !(RightHandEquipedItem As Spell)
			If	ActorRef.GetItemCount(LeftHandEquippedItem) > 0
				ActorRef.EquipItem(LeftHandEquippedItem, False, True)
				Utility.Wait(0.2)
			EndIf
		EndIf
		;If LeftHand && ActorRef.GetItemCount(LeftHandEquippedItem) > 0
		;	ActorRef.EquipItemEx(LeftHandEquippedItem, 2, False, True)
		;	Utility.Wait(0.2)
		;EndIf
		itemIndex = Equipment.Length
		While itemIndex > 0
			itemIndex -= 1
			If Equipment[itemIndex] As Armor
				If ActorRef.GetItemCount(Equipment[itemIndex]) > 0
					ActorRef.EquipItem(Equipment[itemIndex],False, True)
					Utility.Wait(0.2)
				EndIf
			EndIf
		EndWhile
	EndIf
EndFunction

Bool Function bIsTypeLegit( Form KItem)
	Int iType = KItem.GetType()
	If ( KItem.GetWeight() > 0.0 ) && ( ( iType == 26 ) || ( iType == 42 ) || ( iType == 27 ) || ( iType == 46 ) || ( iType == 30 ) || ( iType == 32 ) || ( iType == 23 ) || ( iType == 52 ) || ( iType == 41 ) )
		Return True
	EndIf
	Return False
EndFunction

Bool Function bGuardCanSendToJail()
	bool bResult = False
	If ( Attacker && !Attacker.IsDead() )
		If ( Attacker.IsGuard() )
			If ( PlayerRef.GetDistance(Attacker) < 2000.0 )
				If ( Attacker.GetCrimeFaction().GetCrimeGold() > 0 )
					bResult =  True
				EndIf
			EndIf
		EndIf
	EndIf
	If !bResult
		Int i = 0
		Actor RandomActor
		Bool bBreak = False
		While ( ( i < 15 ) && !bBreak )
			i += 1
			RandomActor = Game.FindRandomActorFromRef(PlayerRef,2000)
			If RandomActor
				If RandomActor != Game.GetPlayer()
					If !RandomActor.IsDead()
						If RandomActor.IsGuard()
							If RandomActor.GetCrimeFaction().GetCrimeGold() > 0
								Attacker = RandomActor
								bResult = True
								bBreak = True
							EndIf
						EndIf
					EndIf
				EndIf
			Else
				bBreak = True ;No Actor is around.
			EndIf
		EndWhile
	EndIf
	Return bResult
EndFunction

Bool Function bInBeastForm()
	If VampireLordQuest.IsRunning() || WerewolfQuest.IsRunning()
		Return True
	ElseIf ( PlayerRef.GetRace() == WereWolfBeastRace )
		Return True
	ElseIf ( PlayerRef.GetRace() == DLC1VampireBeastRace )
		Return True
	EndIf
	Return False
Endfunction

Bool Function bInSameLocation(Location Loc)
    If !Loc
		Return False
	EndIf
	If PlayerMarker.IsInLocation(Loc)
		Return True
	EndIf
	If PlayerMarker.GetCurrentLocation()
		If PlayerMarker.GetCurrentLocation().IsSameLocation(Loc,HoldKeyword)
			Return True
		EndIf
	EndIf
	Return False
EndFunction

Bool Function bIsArrived(ObjectReference Marker)
	Utility.Wait(0.5)
	If (PlayerRef.GetDistance(Marker) <= 500.0)
		If (PlayerRef.GetDistance(PlayerMarker) >= 2500.0)
			Return True
		EndIf
	EndIf
	Return False
EndFunction

ObjectReference Function FindMarkerByDistance()
	Float fDistance
	ObjectReference Marker
	If ( ExcludedMarkerList.find(DetachMarker1) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == DetachMarker1.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(DetachMarker1) ) ) 
				If ( PlayerMarker.GetDistance(DetachMarker1) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(DetachMarker1)
					Marker = DetachMarker1
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(DetachMarker2) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == DetachMarker2.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(DetachMarker2) ) ) 
				If ( PlayerMarker.GetDistance(DetachMarker2) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(DetachMarker2)
					Marker = DetachMarker2
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(DetachMarker3) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == DetachMarker3.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(DetachMarker3) ) ) 
				If ( PlayerMarker.GetDistance(DetachMarker3) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(DetachMarker3)
					Marker = DetachMarker3
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(LocationMarker) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == LocationMarker.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(LocationMarker) ) ) 
				If ( PlayerMarker.GetDistance(LocationMarker) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(LocationMarker)
					Marker = LocationMarker
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(CellLoadMarker) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == CellLoadMarker.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(CellLoadMarker) ) ) 
				If ( PlayerMarker.GetDistance(CellLoadMarker) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(CellLoadMarker)
					Marker = CellLoadMarker
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(LocationMarker2) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == LocationMarker2.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(LocationMarker2) ) ) 
				If ( PlayerMarker.GetDistance(LocationMarker2) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(LocationMarker2)
					Marker = LocationMarker2
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(CellLoadMarker2) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == CellLoadMarker2.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(CellLoadMarker2) ) ) 
				If ( PlayerMarker.GetDistance(CellLoadMarker2) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(CellLoadMarker2)
					Marker = CellLoadMarker2
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(CustomMarker) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == CustomMarker.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(CustomMarker) ) )
				If ( PlayerMarker.GetDistance(CustomMarker) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(CustomMarker)
					Marker = CustomMarker
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(SleepMarker) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == SleepMarker.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(SleepMarker) ) ) 
				If ( PlayerMarker.GetDistance(SleepMarker) >= 3000.0) 
					fDistance = PlayerMarker.GetDistance(SleepMarker)
					Marker = SleepMarker
				EndIf
			EndIf
		EndIf
	EndIf
	If ( Marker && fDistance && fDistance <= 50000.0 )
		Return Marker
	EndIf
	Return None
EndFunction

ObjectReference Function FindCityMarkerByDistance()
	float fDistance
	ObjectReference Marker
	Int iIndex
	If ExternalMarkerList.GetSize() > 0
		iIndex = Min(100,ExternalMarkerList.GetSize())
		While iIndex > 0
			iIndex -= 1
			If( ExcludedMarkerList.find( ExternalMarkerList.GetAt( iIndex ) As ObjectReference ) < 0 )
				If ( !fDistance || ( fDistance > PlayerMarker.GetDistance( ExternalMarkerList.GetAt( iIndex ) As ObjectReference ) ) )
					If ( PlayerMarker.GetDistance(ExternalMarkerList.GetAt( iIndex ) As ObjectReference) >= 3000.0)
						fDistance = PlayerMarker.GetDistance( ExternalMarkerList.GetAt( iIndex ) As ObjectReference )
						Marker = ExternalMarkerList.GetAt( iIndex ) As ObjectReference
					EndIf
				EndIf
			EndIf
		EndWhile
	EndIf
	If PlayerMarker.IsInInterior()
		iIndex = MarkerList.GetSize()
		While iIndex > 0
			iIndex -= 1
			If ConfigMenu.bRespawnPointsFlags[iIndex]
				If ( PlayerMarker.GetParentCell() == ( MarkerList.GetAt(iIndex) As ObjectReference ).GetParentCell() )
					If( ExcludedMarkerList.find( MarkerList.GetAt(iIndex) As ObjectReference ) < 0 )
						If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) ) )
							If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0) 
								fDistance = PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference)
								Marker = MarkerList.GetAt(iIndex) As ObjectReference
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndWhile
	Else
		iIndex = CityMarkersList.GetSize()
		While iIndex > 0
			iIndex -= 1
			If ConfigMenu.bRespawnPointsFlags[iIndex]
				If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(CityMarkersList.GetAt(iIndex) As ObjectReference) ) )
					If ( PlayerMarker.GetDistance(CityMarkersList.GetAt(iIndex) As ObjectReference) >= 3000.0) 
						fDistance = PlayerMarker.GetDistance(CityMarkersList.GetAt(iIndex) As ObjectReference)
						Marker = MarkerList.GetAt(iIndex) As ObjectReference
					EndIf
				EndIf
			EndIf
		EndWhile
	EndIf
	If ( Marker && fDistance && fDistance <= 100000.0 )
		Return Marker
	EndIf
	Return None
Endfunction

ObjectReference Function FindMarkerByLocation()
	If ( ExcludedMarkerList.find(DetachMarker2) < 0 )
		If ( bInSameLocation( DetachMarker2.GetCurrentLocation() ) || ( IsInInteriorActual(PlayerRef) && !IsInInteriorActual(DetachMarker2) ) ) 
			If ( PlayerMarker.GetDistance(DetachMarker2) >= 3000.0 )
				Return DetachMarker2
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(DetachMarker1) < 0 )
		If ( bInSameLocation( DetachMarker1.GetCurrentLocation() ) || ( IsInInteriorActual(PlayerRef) && !IsInInteriorActual(DetachMarker1) ) )
			If ( PlayerMarker.GetDistance(DetachMarker1) >= 3000.0 )
				Return DetachMarker1
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(LocationMarker) < 0 )
		If bInSameLocation( LocationMarker.GetCurrentLocation() )
			If ( PlayerMarker.GetDistance(LocationMarker) >= 3000.0 )
				Return LocationMarker
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(CellLoadMarker) < 0 )
		If bInSameLocation( CellLoadMarker.GetCurrentLocation() )
			If ( PlayerMarker.GetDistance(CellLoadMarker) >= 3000.0 )
				Return CellLoadMarker
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(CustomMarker) < 0 )
		If bInSameLocation( CustomMarker.GetCurrentLocation() )
			If ( PlayerMarker.GetDistance(CustomMarker) >= 3000.0 )
				Return CustomMarker
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(SleepMarker) < 0 )
		If bInSameLocation( SleepMarker.GetCurrentLocation() )
			If ( PlayerMarker.GetDistance(SleepMarker) >= 3000.0 )
				Return SleepMarker
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(LocationMarker2) < 0 )
		If bInSameLocation( LocationMarker2.GetCurrentLocation() )
			If ( PlayerMarker.GetDistance(LocationMarker2) >= 3000.0 )
				Return LocationMarker2
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(DetachMarker3) < 0 )
		If bInSameLocation( DetachMarker3.GetCurrentLocation() )
			If ( PlayerMarker.GetDistance(DetachMarker3) >= 3000.0 )
				Return DetachMarker3
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(CellLoadMarker2) < 0 )
		If bInSameLocation( CellLoadMarker2.GetCurrentLocation() )
			If ( PlayerMarker.GetDistance(CellLoadMarker2) >= 3000.0 )
				Return CellLoadMarker2
			EndIf
		EndIf
	EndIf
	Int iIndex = LocationsList.GetSize()
	While ( iIndex > 0 )
		iIndex -= 1
		If ( ExcludedMarkerList.find(MarkerList.GetAt(iIndex) As ObjectReference) < 0 )
			If ( iIndex == 4 )
				If ( bInSameLocation(LocationsList.GetAt(iIndex) As Location) || bInSameLocation(HjaalmarchHoldLocation) ) ;Solitude or Morthal
					If ConfigMenu.bRespawnPointsFlags[iIndex]
						If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0 )
							Return ( MarkerList.GetAt(iIndex) As ObjectReference )
						EndIf
					EndIf
				EndIf
			ElseIf ( iIndex == 6 )
				If ( bInSameLocation(LocationsList.GetAt(iIndex) As Location) || bInSameLocation(PaleHoldLocation) ) ;Winterhold or Dawnstar
					If ConfigMenu.bRespawnPointsFlags[iIndex]
						If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0 )
							Return ( MarkerList.GetAt(iIndex) As ObjectReference )
						EndIf
					EndIf
				EndIf
			ElseIf bInSameLocation(LocationsList.GetAt(iIndex) As Location)
				If ConfigMenu.bRespawnPointsFlags[iIndex]
					If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0 )
						Return ( MarkerList.GetAt(iIndex) As ObjectReference )
					EndIf
				EndIf
			EndIf
		EndIf
	EndWhile
	If ExternalMarkerList.GetSize() > 0
		Int jIndex = Min(100, ExternalMarkerList.GetSize())
		While jIndex > 0
			jIndex -= 1
			If ( ExcludedMarkerList.find(ExternalMarkerList.GetAt( jIndex ) As ObjectReference) < 0 )
				If bInSameLocation( ( ExternalMarkerList.GetAt( jIndex ) As ObjectReference ).GetCurrentLocation() )
					If ( PlayerMarker.GetDistance(ExternalMarkerList.GetAt( jIndex ) As ObjectReference) >= 3000.0 )
						Return ( ExternalMarkerList.GetAt( jIndex ) As ObjectReference )
					EndIf
				EndIf
			EndIf
		EndWhile	
	EndIf
EndFunction

ObjectReference Function FindMarkerByOrder()
	If ( ExcludedMarkerList.find(DetachMarker2) < 0 )
		Return DetachMarker2
	EndIf
	If ( ExcludedMarkerList.find(DetachMarker1) < 0 )
		Return DetachMarker1
	EndIf
	If ( ExcludedMarkerList.find(LocationMarker) < 0 )
		Return LocationMarker
	EndIf
	If ( ExcludedMarkerList.find(CellLoadMarker) < 0 )
		Return CellLoadMarker
	EndIf
	If ( ExcludedMarkerList.find(LocationMarker2) < 0 )
		Return LocationMarker2
	EndIf
	If ( ExcludedMarkerList.find(DetachMarker3) < 0 )
			Return DetachMarker3
	EndIf
	If ( ExcludedMarkerList.find(CellLoadMarker2) < 0 )
			Return CellLoadMarker2
	EndIf
	Return None
EndFunction

Bool Function TryToMoveByDistanceFar()
	float fDistance
	ObjectReference Marker
	Int iIndex
	If ExternalMarkerList.GetSize() > 0
		iIndex = Min(100, ExternalMarkerList.GetSize())
		While iIndex > 0
			iIndex -= 1
			If( ExcludedMarkerList.find( ExternalMarkerList.GetAt( iIndex ) As ObjectReference ) < 0 )
				If ( !fDistance || ( fDistance > PlayerMarker.GetDistance( ExternalMarkerList.GetAt( iIndex ) As ObjectReference ) ) )
					If ( PlayerMarker.GetDistance(ExternalMarkerList.GetAt( iIndex ) As ObjectReference) >= 3000.0)
						fDistance = PlayerMarker.GetDistance( ExternalMarkerList.GetAt( iIndex ) As ObjectReference )
						Marker = ExternalMarkerList.GetAt( iIndex ) As ObjectReference
					EndIf
				EndIf
			EndIf
		EndWhile
	EndIf
	If PlayerMarker.IsInInterior()
		iIndex = MarkerList.GetSize()
		While iIndex > 0
			iIndex -= 1
			If ConfigMenu.bRespawnPointsFlags[iIndex]
				If ( PlayerMarker.GetParentCell() == ( MarkerList.GetAt(iIndex) As ObjectReference ).GetParentCell() )
					If( ExcludedMarkerList.find( MarkerList.GetAt(iIndex) As ObjectReference ) < 0 )
						If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) ) )
							If ( PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference) >= 3000.0) 
								fDistance = PlayerMarker.GetDistance(MarkerList.GetAt(iIndex) As ObjectReference)
								Marker = MarkerList.GetAt(iIndex) As ObjectReference
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndWhile
	Else
		iIndex = CityMarkersList.GetSize()
		While iIndex > 0
			iIndex -= 1
			If ConfigMenu.bRespawnPointsFlags[iIndex]
				If( ExcludedMarkerList.find( MarkerList.GetAt(iIndex) As ObjectReference ) < 0 )
					If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(CityMarkersList.GetAt(iIndex) As ObjectReference) ) )
						If ( PlayerMarker.GetDistance(CityMarkersList.GetAt(iIndex) As ObjectReference) >= 3000.0) 
							fDistance = PlayerMarker.GetDistance(CityMarkersList.GetAt(iIndex) As ObjectReference)
							Marker = MarkerList.GetAt(iIndex) As ObjectReference
						EndIf
					EndIf
				EndIf
			EndIf
		EndWhile
	EndIf
	If ( ExcludedMarkerList.find(CustomMarker) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == CustomMarker.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(CustomMarker) ) )
				If ( PlayerMarker.GetDistance(CustomMarker) >= 3000.0)
					fDistance = PlayerMarker.GetDistance(CustomMarker)
					Marker = CustomMarker
				EndIf
			EndIf
		EndIf
	EndIf
	If ( ExcludedMarkerList.find(SleepMarker) < 0 )
		If ( !PlayerMarker.IsInInterior() || ( PlayerMarker.GetParentCell() == SleepMarker.GetParentCell() ) )
			If ( !fDistance || ( fDistance > PlayerMarker.GetDistance(SleepMarker) ) ) 
				If ( PlayerMarker.GetDistance(SleepMarker) >= 3000.0) 
					fDistance = PlayerMarker.GetDistance(SleepMarker)
					Marker = SleepMarker
				EndIf
			EndIf
		EndIf
	EndIf
	If ( Marker && fDistance && fDistance <= 500000.0 )
		PlayerRef.MoveTo( Marker )
		If bIsArrived(Marker)
			Return True
		EndIf
		Int i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = Marker
		EndIf
	EndIf
	Return False
EndFunction

Bool Function TryToMoveByDistanceNear()
	Int i = 0
	Int j = 0
	Bool bBreak = False
	ObjectReference Marker
	While ( i < 9 ) && !bBreak
		i += 1
		Marker = FindMarkerByDistance()
		If Marker
			PlayerRef.MoveTo( Marker )
			If bIsArrived(Marker)
				Return True
			EndIf
			j = ExcludedMarkerList.Find(None)
			If j > -1
				ExcludedMarkerList[j] = Marker
			EndIf
		Else
			bBreak = True
		EndIf
	EndWhile
	Return False
EndFunction

Bool Function TryToMoveByLocation()
	Int i = 0
	Int j = 0
	ObjectReference Marker
	While ( i < 12 )
		i += 1
		Marker = FindMarkerByLocation()
		If Marker
			PlayerRef.MoveTo( Marker )
			If bIsArrived(Marker)
				Return True
			EndIf
			j = ExcludedMarkerList.Find(None)
			If j > -1
				ExcludedMarkerList[j] = Marker
			EndIf
		Else
			Return False
		EndIf
	EndWhile
	Return False
EndFunction

Bool Function TryToMoveByOrder()
	Int i = 0
	Int j = 0
	ObjectReference Marker
	While ( i < 7 )
		i += 1
		Marker = FindMarkerByOrder()
		If Marker
			PlayerRef.MoveTo( Marker )
			If bIsArrived(Marker)
				Return True
			EndIf
			j = ExcludedMarkerList.Find(None)
			If j > -1
				ExcludedMarkerList[j] = Marker
			EndIf
		Else
			Return False
		EndIf
	EndWhile
	Return False
EndFunction

Bool Function TryToMoveByDistanceCity()
	ObjectReference Marker
	Marker = FindCityMarkerByDistance()
	If Marker
		PlayerRef.MoveTo( Marker )
		If bIsArrived(Marker)
			Return True
		EndIf
		Int i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = Marker
		EndIf
	EndIf
	Return False
EndFunction

Function InitializeExcludedMarkers()
	 ExcludedMarkerList = New ObjectReference[128]
	Int i
	If !bCanTeleportToDynMarker(DetachMarker1)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = DetachMarker1
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(DetachMarker2)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = DetachMarker2
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(DetachMarker3)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = DetachMarker3
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(CellLoadMarker)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = CellLoadMarker
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(CellLoadMarker2)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = CellLoadMarker2
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(LocationMarker)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = LocationMarker
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(LocationMarker2)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = LocationMarker2
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(CustomMarker)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = CustomMarker
		EndIf
	EndIf
	If !bCanTeleportToDynMarker(SleepMarker)
		i = ExcludedMarkerList.Find(None)
		If i > -1
			ExcludedMarkerList[i] = SleepMarker
		EndIf
	EndIf
	If ExternalMarkerList.GetSize() > 0
		Int j = Min(100,ExternalMarkerList.GetSize())
		While j > 0
			j -= 1
			If ( ( ExternalMarkerList.GetAt( j ).GetType() != 61 ) || !bCanTeleportToExtMarker( ExternalMarkerList.GetAt( j ) As ObjectReference ) )
				i = ExcludedMarkerList.Find(None)
				If i > -1
					ExcludedMarkerList[i] = ExternalMarkerList.GetAt( j ) As ObjectReference 
				EndIf
			EndIf
		EndWhile
	EndIf		
Endfunction

Function SendToNearestLocation()
	InitializeExcludedMarkers()
	If !TryToMoveByDistanceNear()
		If !TryToMoveByLocation()
			If !TryToMoveByDistanceCity()
				If !TryToMoveByOrder()
					If !TryToMoveByDistanceFar()
						If ( ExcludedMarkerList.find(SleepMarker) < 0 )
							If ( PlayerMarker.GetDistance(SleepMarker) >= 3000.0 )
								PlayerRef.MoveTo(SleepMarker)
								If bIsArrived(SleepMarker)
									Return
								EndIf
							EndIf
						EndIf
						If ( ExcludedMarkerList.find(CustomMarker) < 0 )
							If ( PlayerMarker.GetDistance(CustomMarker) >= 3000.0 )
								PlayerRef.MoveTo(CustomMarker)
								If bIsArrived(CustomMarker)
									Return
								EndIf
							EndIf
						EndIf
						RandomTeleport()
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction
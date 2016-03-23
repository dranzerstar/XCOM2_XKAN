// This is an Unreal Script

class XComGameState_CAClass_Ability extends XComGameState_BaseObject
	dependson(X2TacticalGameRuleset, X2Effect, X2AbilityTemplate)
	native(Core);
	/*
	function EventListenerReturn EverVigilantTurnEndListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	local XComGameState_Unit UnitState;
	local UnitValue NonMoveActionsThisTurn;
	local bool GotValue;
	local StateObjectReference OverwatchRef;
	local XComGameState_Ability OverwatchState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local EffectAppliedData ApplyData;
	local X2Effect VigilantEffect;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(OwnerStateObject.ObjectID));
	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OwnerStateObject.ObjectID));

	if (UnitState.NumAllReserveActionPoints() == 0)     //  don't activate overwatch if the unit is potentially doing another reserve action
	{

			OverwatchRef = UnitState.FindAbility('Overwatch');
			OverwatchState = XComGameState_Ability(History.GetGameStateForObjectID(OverwatchRef.ObjectID));
			if (OverwatchState != none)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
				UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
				//  apply the EverVigilantActivated effect directly to the unit
				ApplyData.EffectRef.LookupType = TELT_AbilityShooterEffects;
				ApplyData.EffectRef.TemplateEffectLookupArrayIndex = 0;
				ApplyData.EffectRef.SourceTemplateName = 'EverVigilantTrigger';
				ApplyData.PlayerStateObjectRef = UnitState.ControllingPlayer;
				ApplyData.SourceStateObjectRef = UnitState.GetReference();
				ApplyData.TargetStateObjectRef = UnitState.GetReference();
				VigilantEffect = class'X2Effect'.static.GetX2Effect(ApplyData.EffectRef);
				`assert(VigilantEffect != none);
				VigilantEffect.ApplyEffect(ApplyData, UnitState, NewGameState);

				if (UnitState.NumActionPoints() == 0)
				{
					//  give the unit an action point so they can activate overwatch										
					UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);					
				}
				UnitState.SetUnitFloatValue(class'X2Ability_SpecialistAbilitySet'.default.EverVigilantEffectName, 1, eCleanup_BeginTurn);
				
				NewGameState.AddStateObject(UnitState);
				`TACTICALRULES.SubmitGameState(NewGameState);
				return OverwatchState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID);
			}
		
	}

	return ELR_NoInterrupt;
}
*/
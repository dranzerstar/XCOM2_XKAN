
class X2AbilityTarget_Cursor_ex extends X2AbilityTargetStyle native(Core);

var bool    bRestrictToWeaponRange;
var int     IncreaseWeaponRange;
var bool    bRestrictToSquadsightRange;
var int     FixedAbilityRange;
var int     AdvTorpedoBonusRange;

simulated native function bool IsFreeAiming(const XComGameState_Ability Ability);

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
	local XComGameState_Item SourceWeapon;
	local int RangeInTiles;
	local float RangeInMeters;
	local XComGameState_Unit SourceUnit;
		local XComGameStateHistory History;
		
	History = `XCOMHISTORY;

	if (bRestrictToWeaponRange)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

		if (SourceWeapon != none)
		{
			RangeInTiles = SourceWeapon.GetItemRange(AbilityState);
	
			if( SourceUnit.HasSoldierAbility('Advtorpedoluanching') )
			{
				RangeInMeters=RangeInMeters+AdvTorpedoBonusRange;
			}

			if( RangeInTiles == 0 )
			{
				// This is melee range
				RangeInMeters = class'XComWorldData'.const.WORLD_Melee_Range_Meters;
			}
			else
			{
				RangeInMeters = `UNITSTOMETERS(`TILESTOUNITS(RangeInTiles));
			}

			return RangeInMeters;
		}
	}
	return FixedAbilityRange;
}

DefaultProperties
{
	FixedAbilityRange = -1
}
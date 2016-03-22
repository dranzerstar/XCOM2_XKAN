// This is an Unreal Script

class X2Effect_BroadsideBulges extends X2Effect_BonusArmor config(GameData_SoldierSkills);

var float FlankDamageReduction;
var config int ARMOR_CHANCE, ARMOR_MITIGATION;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return default.ARMOR_CHANCE; }
function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return default.ARMOR_MITIGATION; }

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect)
{
	local int DamageMod;

	local XComGameState_Unit Defender;
	Defender = XComGameState_Unit(TargetDamageable);



	if(Defender.IsFlanked())
	{
		DamageMod = -int(float(CurrentDamage) * FlankDamageReduction);
	}

	return DamageMod;
}


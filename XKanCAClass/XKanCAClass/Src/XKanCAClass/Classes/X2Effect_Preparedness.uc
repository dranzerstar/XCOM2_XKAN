// This is an Unreal Script

class X2Effect_Preparedness extends X2Effect_Persistent
	config(GameData_SoldierSkills);

var config int ConventionalBonus, MagneticBonus, BeamBonus;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage)
{

	local X2WeaponTemplate WeaponTemplate;
	//local X2Condition_AbilitySourceWeapon   WeaponCondition;
	local XComGameState_Item SourceWeapon;


	//History = `XCOMHISTORY;
	//SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

		SourceWeapon = AbilityState.GetSourceWeapon();			
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		//WeaponCondition = new class'X2Condition_AbilitySourceWeapon';

			if (WeaponTemplate.WeaponCat != 'Torpedo_sub' && SourceWeapon != none)    // So It doesnt trigger on  torpedo where every bullet is the first of the clip
			{

				if( WeaponTemplate.iClipSize == SourceWeapon.Ammo )
				{
						if (WeaponTemplate.WeaponTech == 'magnetic')
							return default.MagneticBonus;
						if (WeaponTemplate.WeaponTech == 'beam')
							return default.BeamBonus;
						if (WeaponTemplate.WeaponTech == 'conventional')
							return default.ConventionalBonus;
				}
			}




		
	return 0;
}





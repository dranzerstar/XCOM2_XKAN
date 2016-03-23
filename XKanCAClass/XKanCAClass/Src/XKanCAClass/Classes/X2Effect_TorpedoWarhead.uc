// This is an Unreal Script

class X2Effect_TorpedoWarhead extends X2Effect_Persistent config(GameData_SoldierSkills);

var config int ConventionalWarhead;
var config int MagneticWarhead;
var config int BeamWarhead;


function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();


	
	//  make sure the ammo that created this effect is loaded into the weapon
	if (SourceWeapon != none )
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate.WeaponCat == 'Torpedo_sub')
		{


			if (WeaponTemplate.WeaponTech == 'magnetic')
				return default.MagneticWarhead;
			if (WeaponTemplate.WeaponTech == 'beam')
				return default.BeamWarhead;
			if (WeaponTemplate.WeaponTech == 'conventional')
				return default.ConventionalWarhead;
		}


	}
	return 0;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
}

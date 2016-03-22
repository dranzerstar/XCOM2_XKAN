// This is an Unreal Script

class X2Ability_CAClass extends X2Ability
		dependson (XComGameStateContext_Ability) config(GameData_SoldierSkills); //Find the related ini

var config int FLANK_DAMAGE_REDUCTION;


// Add abilities to game data
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem( BroadsideBulges() );

	
	return Templates;
}





//  BroadsideBulges Skill --------------------------------------------------------------------------
static function X2AbilityTemplate BroadsideBulges() 
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_BroadsideBulges              BulgesEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BroadsideBulges');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_extrapadding"; //todo

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	BulgesEffect = new class'X2Effect_BroadsideBulges';
	BulgesEffect.FlankDamageReduction = default.FLANK_DAMAGE_REDUCTION;
	BulgesEffect.BuildPersistentEffect(1, true, false);
	BulgesEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(BulgesEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, BulgesEffect.ARMOR_MITIGATION);

	return Template;

}
//-------------------------------------------------------------------------------------
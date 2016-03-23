// This is an Unreal Script

class X2Ability_CAClass extends X2Ability
		dependson (XComGameStateContext_Ability) config(GameData_SoldierSkills); //Find the related ini

var config int FLANK_DAMAGE_REDUCTION;
var config int TURBINE_BOOST_MOBILITY;
var config int ADV_LUANCH_RANGE;

// Add abilities to game data
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem( BroadsideBulges() );
	Templates.AddItem( TurbineBoost());
	Templates.AddItem(TorpedoWarhead() ); //TODO

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

//  Torpedo Warhead Skill --------------------------------------------------------------------------
static function X2AbilityTemplate TorpedoWarhead() 
{
	local X2AbilityTemplate						Template;
	local X2Effect_TorpedoWarhead                  Effect;
		local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'TorpedoWarhead');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_extrapadding";      //todo



	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;
	Template.AbilityToHitCalc = default.DeadEye;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	Effect = new class'X2Effect_TorpedoWarhead ';
	Effect.BuildPersistentEffect(1, true, false, false);
	Template.AddShooterEffect(Effect);


	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!




	return Template;

}





//-------------------------------------------------------------------------------------



//  Turbine Boost Skill --------------------------------------------------------------------------
static function X2AbilityTemplate TurbineBoost()
{

	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2Effect_GrantActionPoints    ActionPointEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Effect_PersistentStatChange			PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TurbineBoost');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_runandgun";                      //todo
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 4;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	SuperKillRestrictions(Template, 'RunAndGun_SuperKillCheck');
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'RunAndGun';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = true;


		// Stat Boost
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = 'TurbineBooster';
	PersistentStatChangeEffect.BuildPersistentEffect(1,,,,eGameRule_PlayerTurnEnd);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.TURBINE_BOOST_MOBILITY);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect(PersistentStatChangeEffect);


	return Template;

}

static function SuperKillRestrictions(X2AbilityTemplate Template, name ThisSuperKill)
{
	local X2Condition_UnitValue ValueCondition;
	local X2Effect_SetUnitValue ValueEffect;

	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('RunAndGun_SuperKillCheck', 0, eCheck_Exact,,,'AA_RunAndGunUsed');
	Template.AbilityShooterConditions.AddItem(ValueCondition);

	ValueEffect = new class'X2Effect_SetUnitValue';
	ValueEffect.UnitName = ThisSuperKill;
	ValueEffect.NewValueToSet = 1;
	ValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddShooterEffect(ValueEffect);
}
//-------------------------------------------------------------------------------------







//  Turbine Auto Loader --------------------------------------------------------------------------

/*
static function X2AbilityTemplate TorpedoAutoLoader()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('EverVigilant', "img:///UILibrary_PerkIcons.UIPerk_evervigilant");  //TODO
	Template.AdditionalAbilities.AddItem('TorpedoAutoLoaderTrigger');

	Template.bCrossClassEligible = true;

	return Template;
}

static function X2AbilityTemplate TorpedoAutoLoaderTrigger()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Effect_Persistent               TorpedoAutoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TorpedoAutoLoaderTrigger');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnEnded';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.EverVigilantTurnEndListener;
	Template.AbilityTriggers.AddItem(Trigger);

    VigilantEffect = new class'X2Effect_Persistent';
	VigilantEffect.EffectName = default.EverVigilantEffectName;
	VigilantEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(VigilantEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

*/






//-------------------------------------------------------------------------------------


//  Adv torpedo Mount --------------------------------------------------------------------------

static function X2AbilityTemplate Advtorpedoluanching()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_VolatileMix                  AdvLuanchEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Advtorpedoluanching');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_volatilemix";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	AdvLuanchEffect = new class'X2Effect_VolatileMix';
	AdvLuanchEffect.BuildPersistentEffect(1, true, true, true);
	AdvLuanchEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	AdvLuanchEffect.BonusDamage = default.ADV_LUANCH_RANGE;
	Template.AddTargetEffect(AdvLuanchEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	return Template;
}

//-------------------------------------------------------------------------------------
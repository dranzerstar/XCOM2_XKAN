//---------------------------------------------------------------------------------------
//  FILE:   X2Item_ModExample_Weapon.uc
//  AUTHOR:  Ryan McFall
//           
//	Template classes define new game mechanics & items. In this example a weapon template
//  is created that can be used to add a new type of weapon to the XCom arsenal
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_Torpedo_Weapon extends X2Item config(SubWeaponTorpedo);


var config WeaponDamageValue TORP_TRIPLE_BASEDAMAGE;

var config int TORP_TRIPLE_ISOUNDRANGE;
var config int TORP_TRIPLE_CRITCHANCE;
var config int TORP_TRIPLE_IENVIRONMENTDAMAGE;
var config int TORP_TRIPLE_IPOINTS;
var config int TORP_TRIPLE_ICLIPSIZE;
var config int TORP_TRIPLE_RANGE;
var config int TORP_TRIPLE_RADIUS;


//Template classes are searched for by the game when it starts. Any derived classes have their CreateTemplates function called
//on the class default object. The game expects CreateTemplates to return a list of templates that it will add to the manager
//reponsible for those types of templates. Later, these templates will be automatically picked up by the game mechanics and systems.
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;

	ModWeapons.AddItem(CreateTemplate_Torpedo_Triple_Conventional());
//	ModWeapons.AddItem(CreateTemplate_Torpedo_Quad_Magnetic());
//	ModWeapons.AddItem(CreateTemplate_Torpedo_Pent_Beam());

	return ModWeapons;
}

//Template creation functions form the bulk of a template class. This one builds our custom weapon.
static function X2DataTemplate CreateTemplate_Torpedo_Triple_Conventional()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'TORPEDO_TRIPLE');
	Template.WeaponPanelImage = "_ConventionalRifle";   //TODO
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'Torpedo_sub';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_Base"; //TODO
	Template.Tier = 0;

	Template.BaseDamage =default.TORP_TRIPLE_BASEDAMAGE;
	Template.CritChance =default.TORP_TRIPLE_CRITCHANCE;
	Template.iClipSize =default.TORP_TRIPLE_ICLIPSIZE;
	Template.iSoundRange = default.TORP_TRIPLE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.TORP_TRIPLE_IENVIRONMENTDAMAGE;
	Template.iRange = default.TORP_TRIPLE_RANGE;
	Template.iRadius = default.TORP_TRIPLE_RADIUS;


	Template.NumUpgradeSlots = 0;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;




	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";  //BORROW ROCKET LAUNCHER MODEL AND ANIM


	Template.Abilities.AddItem('StandardShot');	 //TODO


	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	
	Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'Explosion';


	Template.StartingItem = true;
	Template.CanBeBuilt = false;	

	//Template.UpgradeItem = 'TORPEDO_QUAD';


	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.TORP_TRIPLE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.TORP_TRIPLE_RADIUS);



	
	return Template;
}
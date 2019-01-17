// PLAYER GEAR SCRIPT /////////////////////////////////////////////////////////////////////////////
/*
	- This file is a player gear loadout file.
*/
// INIT ///////////////////////////////////////////////////////////////////////////////////////////
params [["_unit",objNull]];
if !(local _unit) exitWith {};

#include "..\..\..\settings\cfg_Player.sqf"


// APPLY NEW ROLE SPECIFIC LOADOUT ////////////////////////////////////////////////////////////////
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

_unit addWeapon _Carbine;
_unit addPrimaryWeaponItem _Carbine_Attach1;
_unit addPrimaryWeaponItem _Carbine_Attach2;
_unit addPrimaryWeaponItem _Carbine_Optic;
_unit addPrimaryWeaponItem _Carbine_Bipod;

_unit forceAddUniform selectRandom _Uniform;

_unit addVest selectRandom _Vest_M;
for "_i" from 1 to 4 do {_unit addItemToVest _Carbine_Ammo;};
for "_i" from 1 to 2 do {_unit addItemToVest _Carbine_Ammo_T;};
for "_i" from 1 to 2 do {_unit addItemToVest _Grenade;};
for "_i" from 1 to 6 do {_unit addItemToVest _Grenade_Smoke;};

_unit addBackpack selectRandom _Backpack_Medic;
if (ace_medical_level == 1) then {
	for "_i" from 1 to 40 do {_unit addItemToBackpack "ACE_fieldDressing";};
	for "_i" from 1 to 15 do {_unit addItemToBackpack "ACE_morphine";};
	for "_i" from 1 to 10 do {_unit addItemToBackpack "ACE_epinephrine";};
	for "_i" from 1 to 10 do {_unit addItemToBackpack "ACE_bloodIV";};
} else {
	_unit addItemToBackpack "ACE_personalAidKit";
	for "_i" from 1 to 25 do {_unit addItemToBackpack "ACE_packingBandage";};
	for "_i" from 1 to 25 do {_unit addItemToBackpack "ACE_elasticBandage";};
	for "_i" from 1 to 10 do {_unit addItemToBackpack "ACE_morphine";};
	for "_i" from 1 to 10 do {_unit addItemToBackpack "ACE_epinephrine";};
	for "_i" from 1 to 6 do {_unit addItemToBackpack "ACE_tourniquet";};
	for "_i" from 1 to 5 do {_unit addItemToBackpack "ACE_salineIV";};
};

_unit addHeadgear selectRandom _Headgear;
_unit addGoggles selectRandom _Goggles;

_unit linkItem "ItemWatch";
_unit linkItem "ItemRadioAcreFlagged";

//RADIO
if (var_personalRadio) then {_unit addItem _ACRE_PRR};

//MAP
if (var_playerMaps == 0) then {
	_unit linkItem "ItemMap";
	_unit linkItem "ItemCompass";
	_unit addItem "ACE_Flashlight_XL50";
};

//REST
for "_i" from 1 to 2 do {_unit addItem "FirstAidKit"};

//NVG
if (var_playerNVG == 0) then {_unit linkItem _NVG};

//PISTOL
if (var_pistolAll) then {
	_unit addWeapon _Pistol;
	_unit addHandgunItem _Pistol_Attach1;
	_unit addHandgunItem _Pistol_Attach2;
	for "_i" from 1 to 3 do {_unit addItem _Pistol_Ammo};
};

//DISABLE SHIFT CLICK ON MAP
onMapSingleClick "_shift";

//TRAITS
_unit setUnitTrait ["medic",true];
_unit setUnitTrait ["engineer",false];

//RANK
_unit setRank "CORPORAL";

//INSIGNIA
private _chooseInsignia = {
	private _exists = isClass (configFile >> "CfgUnitInsignia" >> _this);
	(["",_this] select _exists)
};
player_insignia = "lambs_medic" call _chooseInsignia;
[_unit,player_insignia] call bis_fnc_setUnitInsignia;
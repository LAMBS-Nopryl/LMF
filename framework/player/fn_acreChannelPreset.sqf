// ACRE CHANNEL PRESET ////////////////////////////////////////////////////////////////////////////
/*
    - File that presets the SR channel for selected infantry groups.
*/
// INIT ///////////////////////////////////////////////////////////////////////////////////////////
if !(isClass (configFile >> "CfgPatches" >> "acre_main")) exitWith {};
waitUntil {([] call acre_api_fnc_isInitialized)};

private _id = groupID group player;
private _personalRadio = ["ACRE_PRC343"] call acre_api_fnc_getRadioByType;

//EXIT IF NO RADIO OR NOT LOCAL
if (!local player || {isNil "_personalRadio"}) exitWith {};

//APPLY CHANNEL IF RADIO
if (_id == "FOX6") exitWith {
	[_personalRadio, 6] call acre_api_fnc_setRadioChannel;
};

if (_id == "FOX1") exitWith {
	[_personalRadio, 1] call acre_api_fnc_setRadioChannel;
};

if (_id == "FOX2") exitWith {
	[_personalRadio, 2] call acre_api_fnc_setRadioChannel;
};

if (_id == "FOX3") exitWith {
	[_personalRadio, 3] call acre_api_fnc_setRadioChannel;
};
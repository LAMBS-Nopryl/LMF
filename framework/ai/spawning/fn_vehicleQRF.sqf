// AI VEHICLE QRF /////////////////////////////////////////////////////////////////////////////////
/*
    - Originally by nkenny.
	- Revised by Drgn V4karian.
	- File to spawn a vehicle that functions as QRF. Some have additional infantry as passengers loaded,
      others like the tank will move in on players alone.
	- It is important to note that the player proximity check for spawning will only occur if spawn tickets
	  are set to a higher number than 1. The same goes for the respawn timer.

	- USAGE:
		1) Spawn Position.
		2) Vehicle Type [OPTIONAL] ("CAR", "CARARMED", "TURCK","APC","TANK", "HELITRANSPORT" or "HELIATTACK") (default: "TURCK")
		3) Spawn Tickets [OPTIONAL] (default: 1)
        4) Respawn Timer [OPTIONAL] (default: 300)

	- EXAMPLE: 0 = [this,"TRUCK",1,300] spawn lmf_ai_fnc_vehicleQRF;
*/
// INIT ///////////////////////////////////////////////////////////////////////////////////////////
waitUntil {CBA_missionTime > 0};
private _spawner = [] call lmf_ai_fnc_returnSpawner;
if !(_spawner) exitWith {};

#include "cfg_spawn.sqf"

params [["_spawnPos", [0,0,0]],["_vicType", "TRUCK"],["_tickets", 1],["_respawnTime", 300]];
private _range = 1000;
private _dir = random 360;
if !(_spawnPos isEqualType []) then {_dir = getDir _spawnPos;};
_spawnPos = _spawnPos call CBA_fnc_getPos;
toUpper _vicType;


// PREPARE AND SPAWN //////////////////////////////////////////////////////////////////////////////
private _initTickets = _tickets;
private _grp = grpNull;

while {_initTickets > 0} do {

	//CHECK AIR PROXIMITY
	if ([_spawnPos,_range] call _proximityChecker isEqualTo "airClose") then {
		//IF TOO CLOSE, WAIT UNTIL IT'S FINE, OR UNTIL GROUND PROXIMITY BREAKS
		waitUntil {sleep 5; [_spawnPos,_range] call _proximityChecker isEqualTo "airDistance" || {[_spawnPos,_range] call _proximityChecker isEqualTo "groundClose"}};
	};
	//EXIT IF GROUND PROXIMITY LIMIT HAS BEEN BROKEN
	if ([_spawnPos,_range] call _proximityChecker isEqualTo "groundClose") exitWith {};

    //IF PROXIMITY IS FINE
    private _veh = objNull;

    //IF CAR
    if (_vicType == "CAR") then {
        _veh = createVehicle [selectRandom _car, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _dir;
        _vehType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");

        //CREW
        private _type = selectRandom _team;
        _grp = [_spawnPos,var_enemySide,_type] call BIS_fnc_spawnGroup;
        _grp deleteGroupWhenEmpty true;
        _grp setGroupIDGlobal [format ["Vehicle QRF: %1 (%2)",_vehType, groupId _grp]];
        _grp addVehicle _veh;
        {_x moveInAny _veh;} forEach units _grp;
        _grp enableIRLasers false;
	    _grp enableGunLights "ForceOff";

        //TASK
        0 = [_grp] spawn lmf_ai_fnc_taskUpdateWP;
        waitUntil {sleep 5; (leader _grp) call BIS_fnc_enemyDetected || {{alive _x} count units _grp < 1} || {!alive _veh}};
        0 = [_grp] spawn lmf_ai_fnc_taskAssault;
    };

    //IF CARARMED
    if (_vicType == "CARARMED") then {
        _veh = createVehicle [selectRandom _carArmed, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _dir;
        _vehType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");

        //CREW
        private _type = selectRandom _sentry;
        _grp = [_spawnPos,var_enemySide,_type] call BIS_fnc_spawnGroup;
        _grp deleteGroupWhenEmpty true;
        _grp setGroupIDGlobal [format ["Vehicle QRF: %1 (%2)",_vehType, groupId _grp]];
        _grp addVehicle _veh;
        {_x moveInAny _veh;} forEach units _grp;

        //TASK
        _grp setBehaviour "AWARE";
        0 = [_grp] spawn lmf_ai_fnc_taskUpdateWP;
    };

    //IF TRUCK
    if (_vicType == "TRUCK") then {
        _veh = createVehicle [selectRandom _truck, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _dir;
        _vehType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");

        //CREW
        private _type = selectRandom _squad;
        _grp = [_spawnPos,var_enemySide,_type] call BIS_fnc_spawnGroup;
        _grp deleteGroupWhenEmpty true;
        _grp setGroupIDGlobal [format ["Vehicle QRF: %1 (%2)",_vehType, groupId _grp]];
        {_x moveInAny _veh;} forEach units _grp;
         _grp enableIRLasers false;
	    _grp enableGunLights "ForceOff";

        //TASK
        0 = [_grp] spawn lmf_ai_fnc_taskUpdateWP;
        waitUntil {sleep 5; (leader _grp) call BIS_fnc_enemyDetected || {{alive _x} count units _grp < 1} || {!alive _veh}};
        0 = [_grp] spawn lmf_ai_fnc_taskAssault;
    };

    //IF APC
    if (_vicType == "APC") then {
        _veh = createVehicle [selectRandom _apc, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _dir;
        _vehType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");

        //CREW
        _grp = [_spawnPos,var_enemySide,_vehicleCrew] call BIS_fnc_spawnGroup;
        _grp deleteGroupWhenEmpty true;
        _grp setGroupIDGlobal [format ["Vehicle QRF: %1 (%2)",_vehType, groupId _grp]];
        _grp addVehicle _veh;
        {_x moveInAny _veh;} forEach units _grp;

        //PASSENGERS
        private _type = selectRandom [selectRandom _squad,selectRandom _team];
        private _grp2 = [_spawnPos,var_enemySide,_type] call BIS_fnc_spawnGroup;
        _grp2 deleteGroupWhenEmpty true;
        _grp2 setGroupIDGlobal [format ["Vehicle QRF: Infantry (%1)", groupId _grp2]];
        {_x moveInCargo _veh;} forEach units _grp2;
        _grp2 enableIRLasers false;
	    _grp2 enableGunLights "ForceOff";

        //TASK
        0 = [_grp] spawn lmf_ai_fnc_taskUpdateWP;
        //waitUntil {sleep 5; (leader _grp) call BIS_fnc_enemyDetected || {{alive _x} count units _grp < 1} || {!alive _veh} || {{alive _x} count units _grp2 < 1}};
        waitUntil {sleep 5; (behaviour (leader _grp) == "COMBAT" && {count ((leader _grp) targets [true, 400]) > 0}) || {{alive _x} count units _grp < 1} || {!alive _veh} || {{alive _x} count units _grp2 < 1}};
        waitUntil {sleep 3; !(position _veh isFlatEmpty [-1, -1, -1, -1, 0, false] isEqualTo []);};
        doStop driver _veh;
        doGetOut units _grp2;
        _grp2 leaveVehicle _veh;
        waitUntil {sleep 2; speed _veh > 0 || {{alive _x} count units _grp < 1 || {!alive _veh || {{alive _x} count units _grp2 < 1}}}};
        private _wp = _grp2 addWaypoint [getPos _veh,0];
        _wp setWaypointType "GUARD";
        0 = [_grp2] spawn lmf_ai_fnc_taskAssault;
        sleep 15;
        driver _veh doFollow leader _grp;
    };

    //IF TANK
    if (_vicType == "TANK") then {
        _veh = createVehicle [selectRandom _tank, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _dir;
        _vehType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");

        //CREW
        _grp = [_spawnPos,var_enemySide,_vehicleCrew] call BIS_fnc_spawnGroup;
        _grp deleteGroupWhenEmpty true;
        _grp setGroupIDGlobal [format ["Vehicle QRF: %1 (%2)",_vehType, groupId _grp]];
        _grp addVehicle _veh;
        {_x moveInAny _veh;} forEach units _grp;

        //TASK
        _grp setBehaviour "AWARE";
        0 = [_grp] spawn lmf_ai_fnc_taskUpdateWP;
    };

    //IF HELICOPTER TRANSPORT
    if (_vicType == "HELITRANSPORT") then {
        _veh = createVehicle [selectRandom _heli_Transport, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _dir;
        _vehType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");

        //CREW
        _grp = [_spawnPos,var_enemySide,_heliCrew] call BIS_fnc_spawnGroup;
        _grp deleteGroupWhenEmpty true;
        _grp setGroupIDGlobal [format ["Vehicle QRF: %1 (%2)",_vehType, groupId _grp]];
        _grp addVehicle _veh;
        {_x moveInAny _veh;} forEach units _grp;
        _veh flyInHeightASL [100,100,100];
        _veh flyInHeight 100;

        //PASSENGERS
        private _type = selectRandom _squad;
        private _grp2 = [_spawnPos,var_enemySide,_type] call BIS_fnc_spawnGroup;
        _grp2 deleteGroupWhenEmpty true;
        _grp2 setGroupIDGlobal [format ["Vehicle QRF: Infantry (%1)", groupId _grp2]];
        {_x moveInCargo _veh;} forEach units _grp2;
        _grp2 enableIRLasers false;
	    _grp2 enableGunLights "ForceOff";

        //TASK
        0 = [_grp] spawn lmf_ai_fnc_taskUpdateWP;
        //waitUntil {sleep 5; (leader _grp) call BIS_fnc_enemyDetected || {{alive _x} count units _grp < 1} || {!alive _veh} || {{alive _x} count units _grp2 < 1}};
        waitUntil {sleep 5; (behaviour (leader _grp) == "COMBAT" && {count ((leader _grp) targets [true, 600]) > 0}) || {{alive _x} count units _grp < 1} || {!alive _veh} || {{alive _x} count units _grp2 < 1}};
        doGetOut units _grp2;
        _grp2 leaveVehicle _veh;
        waitUntil {sleep 1; isTouchingGround _veh || {{alive _x} count units _grp < 1 || {!alive _veh || {{alive _x} count units _grp2 < 1}}}};
        private _wp = _grp2 addWaypoint [getPos _veh,0];
        _wp setWaypointType "GUARD";
        0 = [_grp2] spawn lmf_ai_fnc_taskAssault;

        //MAKE HELICOPTER FLY AWAY AND DESPAWN ONCE OUT OF SIGHT
        private _dropPos = getPos _veh;
        private _flyAwayDir = _spawnPos getDir _dropPos;
        _grp setCombatMode "BLUE";
        _grp setBehaviourStrong "CARELESS";
        sleep 5;
        _veh doMove (_spawnPos getPos [(_spawnPos distance2D _dropPos) + 10000,_flyAwayDir - 180]);
		waitUntil {sleep 5; allPlayers findIf {_x distance2D _veh < 5000} == -1 || {!alive _veh || {count units _grp < 1}}};
		if (alive _veh && {count units _grp > 0}) then {
			{_veh deleteVehicleCrew _x} count crew _veh;
			deleteVehicle _veh;
		};
    };

    //IF ATTACK HELICOPTER
    if (_vicType == "HELIATTACK") then {
        _veh = createVehicle [selectRandom _heli_Attack, _spawnPos, [], 0, "CAN_COLLIDE"];
        _veh setDir _dir;
        _vehType = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");

        //CREW
        _grp = createGroup var_enemySide;
        [_veh, _grp, false, "",_Pilot] call BIS_fnc_spawnCrew;
        _grp deleteGroupWhenEmpty true;
        _grp setGroupIDGlobal [format ["Vehicle QRF: %1 (%2)",_vehType, groupId _grp]];

        //TASK
        _grp setBehaviour "AWARE";
        0 = [_grp] spawn lmf_ai_fnc_taskUpdateWP;
    };

	//IF THE INITAL TICKETS WERE HIGHER THAN ONE
	if (_tickets > 1) then {
		//WAIT UNTIL EVERYONE DEAD OR GROUND PROXIMITY HAS BEEN BROKEN
		waitUntil {sleep 5; !alive _veh || {{alive _x} count units _grp < 1} || {[_spawnPos,_range] call _proximityChecker isEqualTo "groundClose"}};
        sleep _respawnTime;
	};

    //SUBTRACT TICKET
    _initTickets = _initTickets - 1;
};
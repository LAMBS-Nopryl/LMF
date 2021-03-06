// PLAYER BRIEFING ////////////////////////////////////////////////////////////////////////////////
/*
	- Minimally rewritten by Drgn V4karian, most code originally by nkenny.
	- File that handles player briefing. Collects data from cfg_Briefing.sqf.
*/
// INIT ///////////////////////////////////////////////////////////////////////////////////////////

#include "..\..\..\settings\cfg_Briefing.sqf"

//FUNCTION TO COLLECT AND FORMAT STRING FROM CFG_BRIEFING CORRECLTY
private _collect = {
	_lines = _this;
	private _newline = "";
	{
		_newline = _newline + " - " + _x + "</font><br/>";
	} foreach _lines;
	_newline
};

// DELETE EXISTING SUBJECTS
[] spawn {
   	waitUntil {!isNil "cba_help_DiaryRecordAddons"};

    player removeDiarySubject "cba_help_docs";
	player removeDiarySubject "Units";
	//player removeDiarySubject "Players";
	player removeDiarySubject "Diary";
	player removeDiarySubject "Statistics";
};

// CREATE NEW LMF BRIEFING
player createDiarySubject ["lmf_diary","Briefing"];

// LMF ////////////////////////////////////////////////////////////////////////////////////////////
player createDiarySubject ["Admin","LMF"];

// INFO
player creatediaryrecord ["Admin",["Info", format ["
<br/><font face='PuristaBold' color='#FFBA26' size='16'>LAMBS MISSION FRAMEWORK </font><br/>
<img image='\a3\Modules_F_Curator\Data\portraitAnimalsSheep_ca.paa' color='#36940c' width='20' height='20'/>
<img image='\a3\Modules_F_Curator\Data\portraitAnimalsSheep_ca.paa' color='#317dcc' width='20' height='20'/>
<img image='\a3\Modules_F_Curator\Data\portraitAnimalsSheep_ca.paa' color='#8a4acf' width='20' height='20'/>
<img image='\a3\Modules_F_Curator\Data\portraitAnimalsSheep_ca.paa' color='#a11017' width='20' height='20'/><br/>
<font>Version: <font color='#FFBA26'>%1</font color>
<br/><br/><font >Current mission: %2 (by: %3)</font>
", var_version,briefingName,var_author]], taskNull, "", false];

// ADMIN TOOLS
player creatediaryrecord ["Admin",["Admin Tools", format ["
<br/><font face='PuristaBold' color='#FFBA26' size='16'>OVERVIEW</font><br/>
<font >This will only work if you are an admin or whitelisted as one in LMF.<br/>
Admin tools are only available in-game.</font color><br/><br/>

<font face='PuristaBold' color='#A3FFA3'>START MISSION:</font><br/>
<execute expression='[player] call lmf_admin_fnc_endWarmup'> - Press here to start the mission</execute><br/><br/>

<font face='PuristaBold' color='#66CBFF'>RESPAWN:</font><br/>
<execute expression='[player] call lmf_admin_fnc_respawnWave'> - Press here to trigger a respawn wave</execute><br/><br/>

<font face='PuristaBold' color='#66CBFF'>ZEUS:</font><br/>
<execute expression='[player] remoteExec [""lmf_admin_fnc_assignZeus"",2]'> - Press here to get zeus access</execute><br/><br/>

<font face='PuristaBold' color='#66CBFF'>PERFORMANCE:</font><br/>
<execute expression='[player] remoteExec [""lmf_admin_fnc_initPerformance"",2]'> - Press here to check server/headless FPS</execute><br/><br/>

<font face='PuristaBold' color='#db4343'>END MISSION:</font><br/>
<execute expression='[player, true] call lmf_admin_fnc_endMission'> - Press here to end mission: COMPLETED</execute><br/>
<execute expression='[player, false] call lmf_admin_fnc_endMission'> - Press here to end mission: FAILED</execute>
"]], taskNull, "", false];


// TESTERS ////////////////////////////////////////////////////////////////////////////////////////
if (_testers != "") then {
player createDiaryrecord ["lmf_diary",["Credits",format ["
<font >%1</font color>
",_testers]], taskNull, "", false];
};

// LOADOUT ////////////////////////////////////////////////////////////////////////////////////////
[] call lmf_player_fnc_loadoutBriefing;

// TO/E ///////////////////////////////////////////////////////////////////////////////////////////
lmf_toeBriefing = player creatediaryrecord ["lmf_diary",["ORBAT",[] call lmf_player_fnc_toeBriefing], taskNull, "", false];

// BRIEFING ///////////////////////////////////////////////////////////////////////////////////////
player creatediaryrecord ["lmf_diary",[format ["OPORD"],format ["
<br/><font face='PuristaBold' color='#FFBA26' size='16'>SITUATION:</font><br/>
<font >%1</font color>
<br/><br/><font face='PuristaBold' >Enemy Forces:</font><br/>
%2
<br/><font face='PuristaBold' >Friendly Forces:</font><br/>
%3
<br/><font face='PuristaBold' size='16' color='#FFBA26'>MISSION:</font><br/>
<font >%4</font color>
<br/><br/><font face='PuristaBold' size='16' color='#FFBA26'>EXECUTION:</font><br/>
%5
<br/><font face='PuristaBold' size='16' color='#FFBA26'>ADMINISTRATION:</font><br/>
%6
",_brf_situation,_brf_enemy call _collect,_brf_friend call _collect,_brf_mission,_brf_execution call _collect,(_brf_administration call _collect) select [0,count (_brf_administration call _collect) - 5]]],taskNull,"",false];
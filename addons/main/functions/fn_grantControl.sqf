#include "..\script_component.hpp"

params ["_uav"];

if (!hasInterface) exitWith {};
if (isNull _uav) exitWith {};

["grantControl start", format ["uav=%1", _uav]] call FUNC(debugLog);

player connectTerminalToUAV _uav;
private _fnc = missionNamespace getVariable ["root_dronefeed_fnc_notifyPlayer", {}];
if (!isNil "_fnc") then {
    ["Drone feed control granted."] call _fnc;
};

#include "..\script_component.hpp"

params ["_uav"];

if (!hasInterface) exitWith {};

player connectTerminalToUAV objNull;
private _fnc = missionNamespace getVariable ["root_dronefeed_fnc_notifyPlayer", {}];
if (!isNil "_fnc") then {
    ["Feed control released."] call _fnc;
};

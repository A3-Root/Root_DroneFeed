#include "..\script_component.hpp"

params ["_uav"];

if (!hasInterface) exitWith {};

["onControlReleased start", format ["uav=%1", _uav]] call FUNC(debugLog);

player connectTerminalToUAV objNull;
private _fnc = missionNamespace getVariable ["root_dronefeed_fnc_notifyPlayer", {}];
if (!isNil "_fnc") then {
    ["Feed control released."] call _fnc;
};

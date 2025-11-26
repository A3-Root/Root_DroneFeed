#include "..\script_component.hpp"

params ["_screenId", "_mode"];

["setVision start", format ["screenId=%1 mode=%2 isServer=%3", _screenId, _mode, isServer]] call FUNC(debugLog);

if (!isServer) exitWith {
    [_screenId, _mode] remoteExec ["root_dronefeed_fnc_setVision", 2];
};

private _screens = missionNamespace getVariable [QGVAR(screens), []];
private _index = _screens findIf {(_x select 0) isEqualTo _screenId};
if (_index == -1) exitWith {};

(_screens select _index) set [5, _mode max 0 min 2];
missionNamespace setVariable [QGVAR(screens), _screens, true];

[_screens] remoteExec ["root_dronefeed_fnc_updateScreens", 0, true];

#include "..\script_component.hpp"

params ["_screenId", "_value"];

if (!isServer) exitWith {
    [_screenId, _value] remoteExec ["root_dronefeed_fnc_setFov", 2];
};

private _screens = missionNamespace getVariable [QGVAR(screens), []];
private _index = _screens findIf {(_x select 0) isEqualTo _screenId};
if (_index == -1) exitWith {};

(_screens select _index) set [4, _value max 0.01 min 1];
missionNamespace setVariable [QGVAR(screens), _screens, true];

[_screens] remoteExec ["root_dronefeed_fnc_updateScreens", 0, true];

#include "..\script_component.hpp"

params ["_screenId"];

["removeScreen start", format ["screenId=%1 isServer=%2", _screenId, isServer]] call FUNC(debugLog);

if (!isServer) exitWith {
    [_screenId] remoteExec ["root_dronefeed_fnc_removeScreen", 2];
};

private _screens = missionNamespace getVariable [QGVAR(screens), []];
private _index = _screens findIf {(_x select 0) isEqualTo _screenId};
if (_index == -1) exitWith {};

_screens deleteAt _index;
missionNamespace setVariable [QGVAR(screens), _screens, true];

[_screens] remoteExec ["root_dronefeed_fnc_updateScreens", 0, true];

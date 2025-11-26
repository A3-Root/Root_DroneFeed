#include "..\script_component.hpp"

params ["_screenId", "_caller"];

if (!isServer) exitWith {
    [_screenId, _caller] remoteExec ["root_dronefeed_fnc_releaseControl", 2];
};

private _screens = missionNamespace getVariable [QGVAR(screens), []];
private _index = _screens findIf {(_x select 0) isEqualTo _screenId};
if (_index == -1) exitWith {};

private _uav = (_screens select _index) select 2;
if (isNull _uav) exitWith {};

private _controllers = missionNamespace getVariable [QGVAR(controllers), []];
private _existingIndex = _controllers findIf {(_x select 0) isEqualTo _uav};
if (_existingIndex == -1) exitWith {};

private _entry = _controllers select _existingIndex;
if ((_entry select 1) isNotEqualTo _caller) exitWith {
    ["You do not control this feed."] remoteExec ["root_dronefeed_fnc_notifyPlayer", _caller];
};

_controllers deleteAt _existingIndex;
missionNamespace setVariable [QGVAR(controllers), _controllers, true];

[_uav] remoteExec ["root_dronefeed_fnc_onControlReleased", _caller];

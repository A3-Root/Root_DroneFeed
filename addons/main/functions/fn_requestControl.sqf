#include "..\script_component.hpp"

params ["_screenId", "_caller"];

if (!isServer) exitWith {
    [_screenId, _caller] remoteExec ["root_dronefeed_fnc_requestControl", 2];
};

private _screens = missionNamespace getVariable [QGVAR(screens), []];
private _index = _screens findIf {(_x select 0) isEqualTo _screenId};
if (_index == -1) exitWith {};

private _screenEntry = _screens select _index;
_screenEntry params ["", "", "_uav", "", "", "", "_allowAll"];

if (isNull _uav) exitWith {};

if (!_allowAll && {isNull (getAssignedCuratorLogic _caller)}) exitWith {
    ["Only Zeus can control this feed."] remoteExec ["root_dronefeed_fnc_notifyPlayer", _caller];
};

private _terminals = missionNamespace getVariable [QGVAR(terminalClasses), []];
private _items = assignedItems _caller + items _caller;
private _hasTerminal = _items findIf {_x in _terminals} > -1;
if (!_hasTerminal) exitWith {
    ["A vanilla UAV terminal is required."] remoteExec ["root_dronefeed_fnc_notifyPlayer", _caller];
};

private _controllers = missionNamespace getVariable [QGVAR(controllers), []];
private _existingIndex = _controllers findIf {(_x select 0) isEqualTo _uav};
if (_existingIndex > -1) then {
    private _current = _controllers select _existingIndex;
    if (!isNull (_current select 1) && {alive (_current select 1)} && {(_current select 1) != _caller}) exitWith {
        ["Another player already has feed control."] remoteExec ["root_dronefeed_fnc_notifyPlayer", _caller];
    };
    _controllers deleteAt _existingIndex;
};

_controllers pushBack [_uav, _caller];
missionNamespace setVariable [QGVAR(controllers), _controllers, true];

[_uav] remoteExec ["root_dronefeed_fnc_grantControl", _caller];

#include "..\script_component.hpp"

params ["_screen", "_uav", "_fov", "_visionMode", "_allowAll", ["_requester", objNull]];

if (!isServer) exitWith {
    [_screen, _uav, _fov, _visionMode, _allowAll, _requester] remoteExec ["root_dronefeed_fnc_registerScreen", 2];
};

private _debugEnabled = missionNamespace getVariable [QGVAR(debugEnabled), false];
private _logDebug = {
    params ["_message"];
    diag_log text format ["[Roots Drone Feed][registerScreen] %1 | stack: %2", _message, diag_stacktrace];
};
if (_debugEnabled) then {
    ["registerScreen invoked", format ["screen=%1 uav=%2 fov=%3 vision=%4 allowAll=%5 requester=%6 isServer=%7", _screen, _uav, _fov, _visionMode, _allowAll, _requester, isServer]] call _logDebug;
};

private _owner = owner _requester;
if (isNil "remoteExecutedOwner") then {
    // keep default
} else {
    _owner = remoteExecutedOwner;
};
if (isNull _requester) then {
    _owner = 0;
};
private _notifyTarget = _owner;
if (isNull _requester) then {
    // leave owner
} else {
    _notifyTarget = _requester;
};

if (isNull _screen || {isNull _uav}) exitWith {
    ["Screen or UAV no longer exists."] remoteExec ["root_dronefeed_fnc_notifyPlayer", _notifyTarget];
    if (_debugEnabled) then {["Screen or UAV missing", format ["screen=%1 uav=%2", _screen, _uav]] call _logDebug;};
};

private _screens = missionNamespace getVariable [QGVAR(screens), []];
private _max = missionNamespace getVariable [QGVAR(maxScreens), 8];

if (_max > 0 && {(count _screens) >= _max}) exitWith {
    ["Maximum number of Roots Drone Feed screens reached."] remoteExec ["root_dronefeed_fnc_notifyPlayer", _notifyTarget];
    if (_debugEnabled) then {["Screen limit reached", format ["max=%1 current=%2", _max, count _screens]] call _logDebug;};
};

private _nextId = missionNamespace getVariable [QGVAR(nextScreenId), 1];
private _rtt = format ["root_df_rtt_%1", _nextId];

_screen setObjectTextureGlobal [0, format ["#(argb,512,512,1)r2t(%1,1)", _rtt]];
_screen setVariable [QGVAR(screenId), _nextId, true];

_screen addEventHandler ["Deleted", {
    params ["_obj"];
    private _sid = _obj getVariable [QGVAR(screenId), -1];
    if (_sid > -1) then {
        [_sid] remoteExec ["root_dronefeed_fnc_removeScreen", 2];
    };
}];

private _entry = [_nextId, _screen, _uav, _rtt, _fov, _visionMode, _allowAll];
_screens pushBack _entry;

missionNamespace setVariable [QGVAR(screens), _screens, true];
missionNamespace setVariable [QGVAR(nextScreenId), _nextId + 1, true];

[_screens] remoteExec ["root_dronefeed_fnc_updateScreens", 0, true];
if (_debugEnabled) then {["Screen registered", format ["id=%1 rtt=%2 totalScreens=%3", _nextId, _rtt, count _screens]] call _logDebug;};

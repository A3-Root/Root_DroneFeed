#include "..\script_component.hpp"

params ["_screens"];

private _states = missionNamespace getVariable [QGVAR(localScreenStates), []];
private _removeFunc = missionNamespace getVariable ["root_dronefeed_fnc_removeLocalScreen", {}];
private _loopFunc = missionNamespace getVariable ["root_dronefeed_fnc_cameraLoop", {}];
private _addActionsFunc = missionNamespace getVariable ["root_dronefeed_fnc_addActions", {}];

private _incomingIds = _screens apply {_x select 0};
{
    private _localId = _x select 0;
    if !(_localId in _incomingIds) then {
        if (isNil "_removeFunc") then {
            // nothing
        } else {
            [_localId] call _removeFunc;
        };
    };
} forEach +_states;

_states = missionNamespace getVariable [QGVAR(localScreenStates), []];

{
    _x params ["_id", "_screen", "_uav", "_rtt", "_fov", "_vision", "_allowAll"];
    private _idx = _states findIf {(_x select 0) isEqualTo _id};

    if (_idx == -1) then {
        if (isNull _screen || {isNull _uav} || {!alive _uav}) then {continue};

        private _cam = "camera" camCreate (getPosASL _uav);
        _cam cameraEffect ["Internal", "Back", _rtt];
        _cam camSetFov _fov;
        _rtt setPiPEffect [_vision];
        _cam camCommit 0;

        private _actions = [];
        if (isNil "_addActionsFunc") then {
            _actions = [];
        } else {
            _actions = [_screen, _id, _allowAll] call _addActionsFunc;
        };
        private _loopHandle = scriptNull;
        if (isNil "_loopFunc") then {
            // keep scriptNull
        } else {
            _loopHandle = [_id, _uav, _cam, _rtt] spawn _loopFunc;
        };

        _states pushBack [_id, _screen, _uav, _rtt, _cam, _vision, _fov, _actions, _loopHandle];
        missionNamespace setVariable [format ["%1_%2", QGVAR(lastTarget), _id], getPos _uav, false];
    } else {
        private _entry = _states select _idx;
        _entry params ["", "", "_storedUav", "_storedRtt", "_cam", "_storedVision", "_storedFov", "", "_loopHandle"];

        if (!isNull _cam) then {
            if (!isNull _uav && {_storedUav isNotEqualTo _uav} && {alive _uav}) then {
                if (isNil "_loopHandle") then {
                    // no handle stored
                } else {
                    terminate _loopHandle;
                };
                _entry set [2, _uav];
                if (isNil "_loopFunc") then {
                    _loopHandle = scriptNull;
                } else {
                    _loopHandle = [_id, _uav, _cam, _storedRtt] spawn _loopFunc;
                };
                _entry set [8, _loopHandle];
            };

            if (_storedFov != _fov) then {
                _entry set [6, _fov];
                _cam camSetFov _fov;
                _cam camCommit 0;
            };

            if (_storedVision != _vision) then {
                _entry set [5, _vision];
                _storedRtt setPiPEffect [_vision];
            };
        };
    };
} forEach _screens;

missionNamespace setVariable [QGVAR(localScreenStates), _states, false];

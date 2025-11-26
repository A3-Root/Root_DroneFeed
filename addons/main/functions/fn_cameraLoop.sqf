#include "..\script_component.hpp"

params ["_screenId", "_uav", "_cam", "_rtt"];

["cameraLoop start", format ["id=%1 uav=%2 cam=%3 rtt=%4", _screenId, _uav, _cam, _rtt]] call FUNC(debugLog);

private _aimFunc = missionNamespace getVariable ["root_dronefeed_fnc_getAimPos", {}];
private _sleep = 0.05;

while {true} do {
    if (isNull _cam || {isNull _uav}) exitWith {};
    if (!alive _uav) exitWith {};

    _cam camSetPos (getPosASL _uav);

    private _aimPosASL = [];
    if (isNil "_aimFunc") then {
        _aimPosASL = [];
    } else {
        _aimPosASL = [_uav] call _aimFunc;
    };

    if (_aimPosASL isNotEqualTo []) then {
        private _aimPosAGL = ASLToAGL _aimPosASL;
        _cam camSetTarget _aimPosAGL;
        missionNamespace setVariable [format ["%1_%2", QGVAR(lastTarget), _screenId], _aimPosAGL, false];
    };

    _cam camCommit _sleep;
    waitUntil {camCommitted _cam};
};

private _removeFnc = missionNamespace getVariable ["root_dronefeed_fnc_removeLocalScreen", {}];
if (isNil "_removeFnc") then {
    // nothing
} else {
    [_screenId] call _removeFnc;
};

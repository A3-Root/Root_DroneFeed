#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Setup drone feed camera tracking
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * None
 *
 * Example:
 * [_feedData] spawn Root_fnc_setupDroneFeed;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _drone = _feedData get "droneObject";
private _camera = _feedData get "cameraObject";
private _feedId = _feedData get "feedId";

if (isNull _drone) exitWith {
    LOG_ERROR_1("setupDroneFeed: No drone for feed %1",_feedId);
};

if (isNull _camera) exitWith {
    LOG_ERROR_1("setupDroneFeed: No camera for feed %1",_feedId);
};

private _dronePos = getPosASL _drone;
private _targetPos = _dronePos vectorAdd ((vectorDir _drone) vectorMultiply 500);
_targetPos set [2, (_dronePos select 2) - 100];

private _targetMarker = createVehicle ["Land_HelipadEmpty_F", ASLToAGL _targetPos, [], 0, "CAN_COLLIDE"];
_feedData set ["targetMarker", _targetMarker];

_camera camSetTarget _targetMarker;
_camera camCommit 0;

private _draw3dInitTime = time;
private _handlerId = addMissionEventHandler ["Draw3D", {
    params ["_feedData", "_drone", "_targetMarker", "_feedId", "_initTime"];

    private _connectedUAV = getConnectedUAV player;
    if (isNull _connectedUAV) exitWith {};
    if (_connectedUAV isNotEqualTo _drone) exitWith {};
    if (!alive _drone) exitWith {};

    private _uavCfg = configOf _drone;
    private _camPosSel = getText (_uavCfg >> "uavCameraGunnerPos");
    if (_camPosSel isEqualTo "") exitWith {};

    private _camDirSel = getText (_uavCfg >> "uavCameraGunnerDir");
    private _camPos = _drone selectionPosition _camPosSel;
    private _camDir = _camPos vectorAdd ((_camPos vectorFromTo (_drone selectionPosition _camDirSel)) vectorMultiply 1e9);
    private _points = lineIntersectsSurfaces [
        _drone modelToWorldVisualWorld _camPos,
        _drone modelToWorldVisualWorld _camDir,
        _drone
    ];

    if (_points isEqualTo []) exitWith {};

    private _aimPosASL = _points select 0 select 0;
    if (_aimPosASL distance2D _targetMarker > 9) then {
        if (local _targetMarker) then {
            _targetMarker setPosASL _aimPosASL;
        } else {
            [_targetMarker, _aimPosASL] remoteExec ["setPosASL", _targetMarker];
        };

        if ((time - _initTime) mod 5 < 0.1) then {
            systemChat format ["DRONEFEED %1: Tracking turret aim at %2", _feedId, mapGridPosition _aimPosASL];
        };
    };
}, [_feedData, _drone, _targetMarker, _feedId, _draw3dInitTime]];

_feedData set ["draw3dHandlerId", _handlerId];
systemChat format ["DRONEFEED: Draw3D tracking added for %1", _feedId];

[{
    params ["_args", "_handle"];
    _args params ["_drone", "_camera", "_targetMarker", "_feedId"];

    if (!alive _drone) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        systemChat format ["DRONEFEED %1: Camera stopped (drone destroyed)", _feedId];
        LOG_DEBUG_1("Drone feed stopped (drone destroyed): %1",_feedId);
    };

    if (isNull _camera) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        systemChat format ["DRONEFEED %1: Camera stopped (camera destroyed)", _feedId];
        LOG_DEBUG_1("Drone feed stopped (camera destroyed): %1",_feedId);
    };

    _camera camSetPos (getPosASL _drone);
    _camera camSetTarget _targetMarker;
    _camera camCommit 0;

}, 0.033, [_drone, _camera, _targetMarker, _feedId]] call CBA_fnc_addPerFrameHandler;

systemChat format ["DRONEFEED: Camera positioning started for %1 (30 FPS)", _feedId];
LOG_DEBUG_1("Drone feed setup complete for %1",_feedId);

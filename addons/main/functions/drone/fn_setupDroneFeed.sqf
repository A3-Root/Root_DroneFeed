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

if (!hasInterface) exitWith {
    LOG_DEBUG("setupDroneFeed: No interface, exiting");
};

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _drone = _feedData get "droneObject";
private _camera = _feedData get "cameraObject";
private _feedId = _feedData get "feedId";

LOG_DEBUG_3("setupDroneFeed: Starting for feed %1, drone %2, camera %3",_feedId,_drone,_camera);

if (isNull _drone) exitWith {
    LOG_ERROR_1("setupDroneFeed: No drone for feed %1",_feedId);
};

if (isNull _camera) exitWith {
    LOG_ERROR_1("setupDroneFeed: No camera for feed %1",_feedId);
};

private _dronePos = getPosASL _drone;
private _targetPos = _dronePos vectorAdd ((vectorDir _drone) vectorMultiply 500);
_targetPos set [2, (_dronePos select 2) - 100];

LOG_DEBUG_2("setupDroneFeed: Initial drone pos %1, initial target pos %2",_dronePos,_targetPos);

private _targetMarker = createVehicle ["Land_HelipadEmpty_F", ASLToAGL _targetPos, [], 0, "CAN_COLLIDE"];
_feedData set ["targetMarker", _targetMarker];

LOG_DEBUG_2("setupDroneFeed: Target marker created %1 at %2",_targetMarker,getPosASL _targetMarker);

_camera camSetTarget _targetMarker;
_camera camCommit 0;

LOG_DEBUG_2("setupDroneFeed: Camera %1 target set to marker %2",_camera,_targetMarker);
systemChat format ["DRONEFEED: Turret tracking started for %1", _feedId];

private _debugCounter = 0;
private _lastKnownAimDir = vectorDir _drone;
[{
    params ["_args", "_handle"];
    _args params ["_drone", "_camera", "_targetMarker", "_feedId", "_debugCounter", "_lastKnownAimDir"];

    if (!alive _drone) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        deleteVehicle _targetMarker;
        systemChat format ["DRONEFEED %1: Camera stopped (drone destroyed)", _feedId];
        LOG_DEBUG_1("Drone feed stopped (drone destroyed): %1",_feedId);
    };

    if (isNull _camera) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        deleteVehicle _targetMarker;
        systemChat format ["DRONEFEED %1: Camera stopped (camera destroyed)", _feedId];
        LOG_DEBUG_1("Drone feed stopped (camera destroyed): %1",_feedId);
    };

    private _uavControl = UAVControl _drone;
    _uavControl params ["_operator", "_seatType", "_personTurret", "_turretPath"];

    private _aimDirUpdated = false;
    if (!isNull _operator && {_seatType != ""}) then {
        private _dronePos = getPosASL _drone;
        private _aimDir = vectorDir _drone;

        if (_seatType == "GUNNER" || _seatType == "DRIVER") then {
            private _gunner = gunner _drone;
            if (!isNull _gunner) then {
                _aimDir = eyeDirection _gunner;
                _lastKnownAimDir = _aimDir;
                _aimDirUpdated = true;
                if (_debugCounter % 90 == 0) then {
                    LOG_DEBUG_4("Drone %1: Using gunner eye direction from %2 (%3), aimDir %4",_feedId,name _operator,_seatType,_aimDir);
                };
            } else {
                private _currentWeapon = _drone currentWeaponTurret _turretPath;
                if (_currentWeapon != "") then {
                    _aimDir = _drone weaponDirection _currentWeapon;
                    _lastKnownAimDir = _aimDir;
                    _aimDirUpdated = true;
                    if (_debugCounter % 90 == 0) then {
                        LOG_DEBUG_4("Drone %1: Using weapon direction, weapon %2, aimDir %3, dronePos %4",_feedId,_currentWeapon,_aimDir,_dronePos);
                    };
                } else {
                    if (_debugCounter % 90 == 0) then {
                        LOG_DEBUG_3("Drone %1: No gunner/weapon, using vectorDir %2 from pos %3",_feedId,_aimDir,_dronePos);
                    };
                };
            };
        } else {
            if (_debugCounter % 90 == 0) then {
                LOG_DEBUG_3("Drone %1: Operator in %2 seat, using vectorDir %3",_feedId,_seatType,_aimDir);
            };
        };

        private _points = lineIntersectsSurfaces [
            _dronePos,
            _dronePos vectorAdd (_aimDir vectorMultiply 10000),
            _drone,
            objNull,
            true,
            1,
            "GEOM",
            "NONE"
        ];

        private _targetPos = [];
        if (count _points > 0) then {
            _targetPos = (_points select 0) select 0;
            if (_debugCounter % 90 == 0) then {
                LOG_DEBUG_2("Drone %1: Line intersect found at %2",_feedId,_targetPos);
            };
        } else {
            // Calculate ground position based on aim direction
            private _distance = 1000;
            if (_aimDir select 2 < -0.1) then {
                private _heightDiff = (_dronePos select 2) - (getTerrainHeightASL _dronePos);
                if (_heightDiff > 0) then {
                    _distance = _heightDiff / (abs (_aimDir select 2));
                    _distance = _distance min 10000;
                };
            };

            _targetPos = _dronePos vectorAdd (_aimDir vectorMultiply _distance);
            private _terrainHeight = getTerrainHeightASL [_targetPos select 0, _targetPos select 1];
            _targetPos set [2, _terrainHeight max 0];

            if (_debugCounter % 90 == 0) then {
                LOG_DEBUG_3("Drone %1: Using calculated ground pos %2 (distance %3m)",_feedId,_targetPos,_distance);
            };
        };

        if (_targetPos distance2D _targetMarker > 5) then {
            _targetMarker setPosASL _targetPos;
            if (_debugCounter % 90 == 0) then {
                LOG_DEBUG_3("Drone %1: Updated marker pos from %2 to %3",_feedId,getPosASL _targetMarker,_targetPos);
            };
        };
    } else {
        // No operator or operator not in control seat - use last known aim direction (turret lock)
        private _dronePos = getPosASL _drone;
        private _aimDir = _lastKnownAimDir;

        if (_debugCounter % 90 == 0) then {
            LOG_DEBUG_2("Drone %1: Using locked turret direction, aimDir %2",_feedId,_aimDir);
        };

        private _points = lineIntersectsSurfaces [
            _dronePos,
            _dronePos vectorAdd (_aimDir vectorMultiply 10000),
            _drone,
            objNull,
            true,
            1,
            "GEOM",
            "NONE"
        ];

        private _targetPos = [];
        if (count _points > 0) then {
            _targetPos = (_points select 0) select 0;
        } else {
            private _distance = 1000;
            if (_aimDir select 2 < -0.1) then {
                private _heightDiff = (_dronePos select 2) - (getTerrainHeightASL _dronePos);
                if (_heightDiff > 0) then {
                    _distance = _heightDiff / (abs (_aimDir select 2));
                    _distance = _distance min 10000;
                };
            };

            _targetPos = _dronePos vectorAdd (_aimDir vectorMultiply _distance);
            private _terrainHeight = getTerrainHeightASL [_targetPos select 0, _targetPos select 1];
            _targetPos set [2, _terrainHeight max 0];
        };

        if (_targetPos distance2D _targetMarker > 5) then {
            _targetMarker setPosASL _targetPos;
        };
    };

    private _camPos = getPosASL _drone;
    _camera camSetPos _camPos;
    _camera camSetTarget _targetMarker;
    _camera camCommit 0;

    if (_debugCounter % 90 == 0) then {
        LOG_DEBUG_4("Drone %1: Camera update - cam pos %2, target %3, marker pos %4",_feedId,_camPos,_targetMarker,getPosASL _targetMarker);
    };

    _args set [4, _debugCounter + 1];
    _args set [5, _lastKnownAimDir];

}, 0.033, [_drone, _camera, _targetMarker, _feedId, _debugCounter, _lastKnownAimDir]] call CBA_fnc_addPerFrameHandler;

systemChat format ["DRONEFEED: Camera positioning started for %1 (30 FPS)", _feedId];
LOG_DEBUG_1("Drone feed setup complete for %1",_feedId);

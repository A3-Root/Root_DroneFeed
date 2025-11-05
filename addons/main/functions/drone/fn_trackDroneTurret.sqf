#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Track drone turret aim point for camera targeting
 *              Runs continuously while player controls UAV
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 * 1: _targetMarker <OBJECT> - Invisible marker to track aim point
 *
 * Return Value:
 * None (runs as background task)
 *
 * Example:
 * [_feedData, _targetMarker] spawn Root_fnc_trackDroneTurret;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [
    ["_feedData", createHashMap, [createHashMap]],
    ["_targetMarker", objNull, [objNull]]
];

private _feedId = _feedData get "feedId";
private _drone = _feedData get "droneObject";

if (isNull _drone || isNull _targetMarker) exitWith {
    LOG_ERROR_1("trackDroneTurret: Invalid parameters for feed %1",_feedId);
};

private _handlerId = format ["ROOT_DRONEFEED_TURRET_%1", _feedId];

[_handlerId, "onEachFrame", {
    params ["_args"];
    _args params ["_drone", "_targetMarker", "_feedId"];

    if (!alive _drone) exitWith {
        [_handlerId, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
        systemChat format ["DRONEFEED: Tracking stopped for %1 (drone dead)", _feedId];
    };

    private _dronePos = getPosASL _drone;
    private _aimDir = vectorDir _drone;

    private _currentWeapon = _drone currentWeaponTurret [0];
    if (_currentWeapon != "") then {
        _aimDir = _drone weaponDirection _currentWeapon;
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
        _targetPos = _dronePos vectorAdd (_aimDir vectorMultiply 1000);
        _targetPos set [2, 0];
    };

    if (local _targetMarker) then {
        _targetMarker setPosASL _targetPos;
    } else {
        [_targetMarker, _targetPos] remoteExec ["setPosASL", _targetMarker];
    };

    if ((time mod 5) < 0.1) then {
        systemChat format ["DRONEFEED %1: Target at %2, Weapon: %3, Dist: %4m", _feedId, mapGridPosition _targetPos, _currentWeapon, round(_dronePos distance _targetPos)];
    };
}, [_drone, _targetMarker, _feedId]] call BIS_fnc_addStackedEventHandler;

systemChat format ["DRONEFEED: Turret tracking started for %1", _feedId];
LOG_DEBUG_1("Turret tracking started for feed %1",_feedId);

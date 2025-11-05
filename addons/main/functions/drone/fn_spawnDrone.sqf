#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Spawn a new drone at specified position and altitude
 *
 * Arguments:
 * 0: _droneClass <STRING> - Drone class name
 * 1: _position <ARRAY> - Spawn position [x,y,z] or [x,y]
 * 2: _altitude <NUMBER> (Optional) - Flying altitude (default: 2000)
 *
 * Return Value:
 * <OBJECT> - Spawned drone, or objNull if failed
 *
 * Example:
 * ["B_UAV_02_dynamicLoadout_F", getPos player, 1500] call Root_fnc_spawnDrone;
 *
 * Public: No
 */

if (!isServer) exitWith {
    LOG_ERROR("spawnDrone must be called on server");
    objNull
};

params [
    ["_droneClass", "", [""]],
    ["_position", [], [[]]],
    ["_altitude", DEFAULT_DRONE_ALTITUDE, [0]]
];

if (_droneClass isEqualTo "") exitWith {
    LOG_ERROR("spawnDrone: Invalid drone class");
    objNull
};

if (_position isEqualTo []) exitWith {
    LOG_ERROR("spawnDrone: Invalid position");
    objNull
};

if (count _position isEqualTo 2) then {
    _position = _position + [_altitude];
};

private _drone = createVehicle [_droneClass, _position, [], 0, "FLY"];

if (isNull _drone) exitWith {
    LOG_ERROR_1("spawnDrone: Failed to create drone: %1",_droneClass);
    objNull
};

createVehicleCrew _drone;
_drone flyInHeight _altitude;

private _group = group _drone;
private _wp = _group addWaypoint [_position, 0];
_wp setWaypointType "LOITER";
_wp setWaypointLoiterType "CIRCLE_L";
_wp setWaypointLoiterRadius 1500;

LOG_INFO_3("Drone spawned: %1 at %2, altitude %3",_droneClass,_position,_altitude);

_drone

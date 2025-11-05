#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Update satellite camera position to new map coordinates
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 * 1: _position <ARRAY> - New position [x,y] or [x,y,z]
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * [_feedData, [1000, 2000]] call Root_fnc_updateSatellitePosition;
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params [
    ["_feedData", createHashMap, [createHashMap]],
    ["_position", [], [[]]]
];

private _feedId = _feedData get "feedId";
systemChat format ["DEBUG: updateSatellitePosition called for feedId=%1, pos=%2", _feedId, _position];

if (_position isEqualTo []) exitWith {
    systemChat "DEBUG: updateSatellitePosition exit - empty position";
    false
};

private _camera = _feedData get "cameraObject";
private _altitude = _feedData get "altitude";

systemChat format ["DEBUG: camera=%1, altitude=%2", if (isNull _camera) then {"NULL"} else {str _camera}, _altitude];

if (isNull _camera) exitWith {
    systemChat "DEBUG: updateSatellitePosition exit - null camera";
    false
};

private _newPos = [_position select 0, _position select 1, _altitude];
systemChat format ["DEBUG: Setting camera to %1 looking at %2", _newPos, [_position select 0, _position select 1, 0]];

_camera camSetPos _newPos;
_camera camSetTarget [_position select 0, _position select 1, 0];
_camera camCommit 1;

systemChat format ["SATELLITE %1: Moved to %2 at %3m altitude", _feedId, mapGridPosition _position, round _altitude];
LOG_DEBUG_2("Satellite position updated to %1 for feed %2",_position,_feedId);

true

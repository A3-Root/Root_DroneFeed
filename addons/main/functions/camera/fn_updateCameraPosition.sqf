#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Update camera position and target
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 * 1: _position <ARRAY> - Camera position [x,y,z] or ASL position
 * 2: _target <ARRAY|OBJECT> (Optional) - Camera target position or object
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * [_feedData, [1000, 2000, 500], [1000, 2000, 0]] call Root_fnc_updateCameraPosition;
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params [
    ["_feedData", createHashMap, [createHashMap]],
    ["_position", [], [[]]],
    ["_target", [], [[], objNull]]
];

private _camera = _feedData get "cameraObject";

if (isNull _camera) exitWith {false};
if (_position isEqualTo []) exitWith {false};

_camera camSetPos _position;

if (_target isNotEqualTo []) then {
    _camera camSetTarget _target;
};

_camera camCommit 0.5;

true

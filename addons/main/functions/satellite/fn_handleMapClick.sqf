#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Handle map click to update satellite camera position
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 * 1: _clickedPos <ARRAY> - Clicked position [x,y,z]
 *
 * Return Value:
 * <BOOLEAN> - True if position was updated
 *
 * Example:
 * [_feedData, _pos] call Root_fnc_handleMapClick;
 *
 * Public: No
 */

params [
    ["_feedData", createHashMap, [createHashMap]],
    ["_clickedPos", [], [[]]]
];

private _feedId = _feedData get "feedId";
systemChat format ["DEBUG: handleMapClick called with feedId=%1, pos=%2", _feedId, _clickedPos];

if (_clickedPos isEqualTo []) exitWith {
    systemChat "DEBUG: handleMapClick exit - empty position";
    false
};

private _feedMode = _feedData get "feedMode";
if (_feedMode isNotEqualTo FEED_MODE_SATELLITE) exitWith {
    systemChat format ["DEBUG: handleMapClick exit - wrong mode %1", _feedMode];
    false
};

systemChat format ["SATELLITE %1: Map clicked at %2", _feedId, mapGridPosition _clickedPos];
private _result = [_feedData, _clickedPos] call FUNC(updateSatellitePosition);
systemChat format ["DEBUG: updateSatellitePosition returned %1", _result];

_result

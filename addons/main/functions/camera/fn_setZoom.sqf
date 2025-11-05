#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Set camera zoom level (Field of View)
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 * 1: _zoomLevel <NUMBER> - Zoom level (1-6) or custom FoV value
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * [_feedData, 3] call Root_fnc_setZoom;
 * [_feedData, 0.25] call Root_fnc_setZoom;
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params [
    ["_feedData", createHashMap, [createHashMap]],
    ["_zoomLevel", 1, [0]]
];

private _camera = _feedData get "cameraObject";

if (isNull _camera) exitWith {false};

private _fov = DEFAULT_CAMERA_FOV;

if (_zoomLevel >= 1 && {_zoomLevel <= 6}) then {
    switch (_zoomLevel) do {
        case 1: {_fov = ZOOM_LEVEL_1};
        case 2: {_fov = ZOOM_LEVEL_2};
        case 3: {_fov = ZOOM_LEVEL_3};
        case 4: {_fov = ZOOM_LEVEL_4};
        case 5: {_fov = ZOOM_LEVEL_5};
        case 6: {_fov = ZOOM_LEVEL_6};
    };
} else {
    _fov = _zoomLevel;
};

_camera camSetFov _fov;
_camera camCommit 0;

[EVENT_CAMERA_ZOOM, [_feedData get "feedId", _zoomLevel]] call CBA_fnc_globalEvent;

LOG_DEBUG_2("Zoom set for feed %1: FoV %2",_feedData get "feedId",_fov);

true

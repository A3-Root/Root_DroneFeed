#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Set camera vision mode (normal, NV, thermal)
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 * 1: _visionMode <NUMBER> - Vision mode (0=normal, 1=NV, 2=thermal)
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * [_feedData, 2] call Root_fnc_setVision;
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params [
    ["_feedData", createHashMap, [createHashMap]],
    ["_visionMode", VISION_MODE_NORMAL, [0]]
];

private _camera = _feedData get "cameraObject";

if (isNull _camera) exitWith {false};

if !(_visionMode in [VISION_MODE_NORMAL, VISION_MODE_NV, VISION_MODE_THERMAL]) exitWith {
    LOG_ERROR_1("setVision: Invalid vision mode: %1",_visionMode);
    false
};

(_feedData get "rttIdentifier") setPiPEffect [_visionMode];
_camera camCommit 0;

[EVENT_CAMERA_VISION, [_feedData get "feedId", _visionMode]] call CBA_fnc_globalEvent;

private _modeName = ["Normal","Night Vision","Thermal"] select _visionMode;
_modeName = _modeName + ".";
LOG_DEBUG_2("Vision mode set for feed %1: %2",_feedData get "feedId",_modeName);

true

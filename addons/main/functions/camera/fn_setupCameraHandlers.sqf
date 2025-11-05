#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Setup CBA event handlers to maintain camera effect
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * [_feedData] call Root_fnc_setupCameraHandlers;
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _camera = _feedData get "cameraObject";

if (isNull _camera) exitWith {false};

private _handlerCode = {
    if (!isNull (getAssignedCuratorLogic player)) exitWith {};
    if (visibleMap) exitWith {};
    if (!isNull (findDisplay 602)) exitWith {};
    if (!isNull (findDisplay 30000)) exitWith {};

    private _registry = call FUNC(getRegistry);
    {
        private _feed = _y;
        private _feedMode = _feed get "feedMode";

        if (_feedMode isEqualTo FEED_MODE_DRONE) then {
            private _feedCam = _feed get "cameraObject";
            if (!isNull _feedCam) then {
                private _rtt = _feed get "rttIdentifier";
                _feedCam cameraEffect ["Internal","Back",_rtt];
                _feedCam camCommit 0;
            };
        };
    } forEach _registry;
};

["unit",_handlerCode, true] call CBA_fnc_addPlayerEventHandler;
["visionMode",_handlerCode, true] call CBA_fnc_addPlayerEventHandler;

LOG_DEBUG_1("Camera handlers setup for feed %1",_feedData get "feedId");

true

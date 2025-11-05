#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Destroy client-side camera for a feed
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * [_feedData] call Root_fnc_destroyCamera;
 *
 * Public: No
 */

if (!hasInterface) exitWith {false};

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _camera = _feedData get "cameraObject";

if (isNull _camera) exitWith {
    LOG_DEBUG_1("destroyCamera: No camera to destroy for feed %1",_feedData get "feedId");
    true
};

_camera cameraEffect ["terminate", "back"];
camDestroy _camera;

_feedData set ["cameraObject", objNull];

private _feedId = _feedData get "feedId";
private _clientFeeds = GET_CLIENT_FEEDS;
_clientFeeds deleteAt _feedId;
SET_CLIENT_FEEDS(_clientFeeds);

LOG_DEBUG_1("Camera destroyed for feed %1",_feedId);

true

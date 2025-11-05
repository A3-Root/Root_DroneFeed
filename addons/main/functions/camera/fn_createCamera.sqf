#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Create client-side camera for feed projection
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * <OBJECT> - Camera object, or objNull if failed
 *
 * Example:
 * [_feedData] call Root_fnc_createCamera;
 *
 * Public: No
 */

if (!hasInterface) exitWith {objNull};

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _feedId = _feedData get "feedId";
private _rttIdentifier = _feedData get "rttIdentifier";
private _feedMode = _feedData get "feedMode";
private _screenObject = _feedData get "screenObject";
private _textureId = _feedData get "screenTextureId";

if (isNull _screenObject) exitWith {
    LOG_ERROR_1("createCamera: Invalid screen object for feed %1",_feedId);
    objNull
};

private _existingCam = _feedData get "cameraObject";
if (!isNull _existingCam) then {
    _existingCam cameraEffect ["terminate", "back"];
    camDestroy _existingCam;
};

private _camera = "camera" camCreate [0, 0, 0];
_camera cameraEffect ["Internal", "Back", _rttIdentifier];
_camera camSetFov DEFAULT_CAMERA_FOV;
_rttIdentifier setPiPEffect [VISION_MODE_NORMAL];
_camera camCommit 0;

_screenObject setObjectTexture [_textureId, format ["#(argb,512,512,1)r2t(%1,1)", _rttIdentifier]];

_feedData set ["cameraObject", _camera];

private _clientFeeds = GET_CLIENT_FEEDS;
_clientFeeds set [_feedId, _feedData];
SET_CLIENT_FEEDS(_clientFeeds);

[_feedData] call FUNC(setupCameraHandlers);

if (_feedMode isEqualTo FEED_MODE_DRONE) then {
    [_feedData] spawn FUNC(setupDroneFeed);
} else {
    [_feedData] call FUNC(setupSatelliteFeed);
};

LOG_DEBUG_2("Camera created for feed %1, RTT: %2",_feedId,_rttIdentifier);

_camera

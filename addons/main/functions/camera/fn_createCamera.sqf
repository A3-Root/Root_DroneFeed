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

if (!hasInterface) exitWith {
    LOG_DEBUG("createCamera: No interface, exiting");
    objNull
};

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _feedId = _feedData get "feedId";
private _rttIdentifier = _feedData get "rttIdentifier";
private _feedMode = _feedData get "feedMode";
private _screenObject = _feedData get "screenObject";
private _textureId = _feedData get "screenTextureId";

LOG_DEBUG_4("createCamera: Starting for feed %1, mode %2, screen %3, RTT %4",_feedId,_feedMode,_screenObject,_rttIdentifier);

if (isNull _screenObject) exitWith {
    LOG_ERROR_1("createCamera: Invalid screen object for feed %1",_feedId);
    objNull
};

private _existingCam = _feedData get "cameraObject";
if (!isNull _existingCam) then {
    LOG_DEBUG_1("createCamera: Destroying existing camera for feed %1",_feedId);
    _existingCam cameraEffect ["terminate", "back"];
    camDestroy _existingCam;
};

private _camera = "camera" camCreate [0, 0, 0];
LOG_DEBUG_2("createCamera: Camera object created %1 for feed %2",_camera,_feedId);

_camera cameraEffect ["Internal", "Back", _rttIdentifier];
_camera camSetFov DEFAULT_CAMERA_FOV;
_rttIdentifier setPiPEffect [VISION_MODE_NORMAL];
_camera camCommit 0;

LOG_DEBUG_3("createCamera: Camera effect set to %1, FOV %2, vision mode %3",_rttIdentifier,DEFAULT_CAMERA_FOV,VISION_MODE_NORMAL);

private _rttString = format ["#(argb,512,512,1)r2t(%1,1)", _rttIdentifier];
_screenObject setObjectTexture [_textureId, _rttString];
LOG_DEBUG_3("createCamera: Screen texture set for feed %1, textureId %2, RTT string %3",_feedId,_textureId,_rttString);

_feedData set ["cameraObject", _camera];

private _clientFeeds = GET_CLIENT_FEEDS;
_clientFeeds set [_feedId, _feedData];
SET_CLIENT_FEEDS(_clientFeeds);

LOG_DEBUG_1("createCamera: Feed data stored in client registry for %1",_feedId);

[_feedData] call FUNC(setupCameraHandlers);
LOG_DEBUG_1("createCamera: Camera handlers setup complete for %1",_feedId);

if (_feedMode isEqualTo FEED_MODE_DRONE) then {
    LOG_DEBUG_1("createCamera: Spawning drone feed setup for %1",_feedId);
    [_feedData] spawn FUNC(setupDroneFeed);
} else {
    LOG_DEBUG_1("createCamera: Starting satellite feed setup for %1",_feedId);
    [_feedData] call FUNC(setupSatelliteFeed);
};

LOG_DEBUG_2("Camera created for feed %1, RTT: %2",_feedId,_rttIdentifier);
systemChat format ["DRONEFEED: Camera created for %1 (%2 mode)", _feedId, _feedMode];

_camera

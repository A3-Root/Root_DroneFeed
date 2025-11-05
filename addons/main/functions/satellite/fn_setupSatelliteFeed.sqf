#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Setup satellite feed camera at specified altitude
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * None
 *
 * Example:
 * [_feedData] spawn Root_fnc_setupSatelliteFeed;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _camera = _feedData get "cameraObject";
private _altitude = _feedData get "altitude";
private _feedId = _feedData get "feedId";
private _screenObject = _feedData get "screenObject";

if (isNull _camera) exitWith {
    LOG_ERROR_1("setupSatelliteFeed: No camera for feed %1",_feedId);
};

private _screenPos = getPosASL _screenObject;
private _startPos = [_screenPos select 0, _screenPos select 1, _altitude];
private _targetPos = [_screenPos select 0, _screenPos select 1, 0];

_camera camSetPos _startPos;
_camera camSetTarget _targetPos;
_camera camCommit 0;

[{
    params ["_args", "_handle"];
    _args params ["_camera", "_feedId"];

    if (isNull _camera) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        LOG_DEBUG_1("Satellite feed stopped (camera destroyed): %1",_feedId);
    };

    private _feedData = [_feedId] call FUNC(getFeedData);
    if (isNil "_feedData") exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
        LOG_DEBUG_1("Satellite feed stopped (feed deleted): %1",_feedId);
    };

    private _cameraPos = getPosASL _camera;
    private _targetPos = [_cameraPos select 0, _cameraPos select 1, 0];
    _camera camSetTarget _targetPos;
    _camera camCommit 0;

}, 0.1, [_camera, _feedId]] call CBA_fnc_addPerFrameHandler;

systemChat format ["SATELLITE %1: Setup at %2m altitude, looking down at %3", _feedId, round _altitude, mapGridPosition _startPos];
LOG_DEBUG_2("Satellite feed setup at altitude %1 for feed %2",_altitude,_feedId);

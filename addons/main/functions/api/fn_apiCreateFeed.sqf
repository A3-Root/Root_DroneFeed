#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Public API to create a drone/satellite feed programmatically
 *
 * Arguments:
 * 0: _screenObject <OBJECT> - Screen object to project feed onto
 * 1: _textureId <NUMBER> - Texture ID on screen object (default: 0)
 * 2: _authorizedUnits <ARRAY> - Array of authorized units/groups/sides
 * 3: _feedMode <STRING> - Feed mode ("DRONE" or "SATELLITE")
 * 4: _droneOrAltitude <OBJECT|NUMBER> - Drone object or satellite altitude
 * 5: _activationRadius <NUMBER> (Optional) - Activation radius in meters (default: 100)
 *
 * Return Value:
 * <STRING> - Feed ID if successful, empty string if failed
 *
 * Example:
 * // Satellite feed
 * [myScreen, 0, [player], "SATELLITE", 1500, 200] call Root_fnc_apiCreateFeed;
 *
 * // Drone feed
 * [myScreen, 0, [west], "DRONE", myDrone, 150] call Root_fnc_apiCreateFeed;
 *
 * Public: Yes
 */

params [
    ["_screenObject", objNull, [objNull]],
    ["_textureId", 0, [0]],
    ["_authorizedUnits", [], [[]]],
    ["_feedMode", "", [""]],
    ["_droneOrAltitude", objNull, [objNull, 0]],
    ["_activationRadius", 100, [0]]
];

if (!isServer) exitWith {
    private _result = [_screenObject, _textureId, _authorizedUnits, _feedMode, _droneOrAltitude, _activationRadius] remoteExecCall [QFUNC(apiCreateFeed), 2];
    _result
};

private _feedId = [_screenObject, _textureId, _authorizedUnits, _feedMode, _droneOrAltitude, _activationRadius, objNull] call FUNC(createFeed);

_feedId

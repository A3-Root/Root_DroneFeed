#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Validate feed configuration parameters
 *
 * Arguments:
 * 0: _config <HASHMAP> - Configuration hashmap to validate
 *
 * Return Value:
 * <ARRAY> - [isValid <BOOLEAN>, errorMessage <STRING>]
 *
 * Example:
 * private _result = [_config] call Root_fnc_validateConfig;
 *
 * Public: No
 */

params [
    ["_config", createHashMap, [createHashMap]]
];

private _screenObject = _config get "screenObject";
if (isNil "_screenObject" || isNull _screenObject) exitWith {
    [false, localize "STR_ROOT_DRONEFEED_ERR_INVALID_SCREEN"]
};

private _authorizedUsers = _config get "authorizedUsers";
if (isNil "_authorizedUsers" || _authorizedUsers isEqualTo []) exitWith {
    [false, localize "STR_ROOT_DRONEFEED_ERR_NO_USERS"]
};

private _feedMode = _config get "feedMode";
if (isNil "_feedMode" || !VALIDATE_FEED_MODE(_feedMode)) exitWith {
    [false, localize "STR_ROOT_DRONEFEED_ERR_INVALID_MODE"]
};

if (_feedMode isEqualTo FEED_MODE_DRONE) then {
    private _drone = _config get "droneObject";
    if (isNil "_drone" || isNull _drone) exitWith {
        [false, localize "STR_ROOT_DRONEFEED_ERR_NO_DRONE"]
    };
};

if (_feedMode isEqualTo FEED_MODE_SATELLITE) then {
    private _altitude = _config get "altitude";
    if (isNil "_altitude" || _altitude <= 0) exitWith {
        [false, localize "STR_ROOT_DRONEFEED_ERR_INVALID_ALTITUDE"]
    };
};

[true, ""]

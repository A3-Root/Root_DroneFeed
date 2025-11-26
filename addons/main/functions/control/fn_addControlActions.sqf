#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Add scroll wheel actions for feed control
 *
 * Arguments:
 * 0: _player <OBJECT> - Player to add actions for
 * 1: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, _feedData] call Root_fnc_addControlActions;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [
    ["_player", objNull, [objNull]],
    ["_feedData", createHashMap, [createHashMap]]
];

if (isNull _player) exitWith {};

private _screenObject = _feedData get "screenObject";
private _feedMode = _feedData get "feedMode";

if (isNull _screenObject) exitWith {};

_screenObject addAction [
    "<t color='#FFD966'>Reset Camera Feed</t>",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments params ["_feedData"];

        private _camera = _feedData get "cameraObject";
        private _rttIdentifier = _feedData get "rttIdentifier";
        private _feedId = _feedData get "feedId";

        if (!isNull _camera && {!isNil "_rttIdentifier"}) then {
            _camera cameraEffect ["Internal", "Back", _rttIdentifier];
            hint parseText format ["<t color='%1'>Camera feed restored for %2</t>", "#8ce10b", _feedId];
            LOG_DEBUG_2("Manual camera reset for feed %1 by %2",_feedId,name _caller);
        } else {
            hint parseText format ["<t color='%1'>Camera feed error - invalid camera or RTT</t>", "#fa4c58"];
            LOG_ERROR_1("Failed to reset camera for feed %1 - invalid camera or RTT",_feedId);
        };
    },
    [_feedData],
    10,
    true,
    true,
    "",
    "true",
    15
];

_screenObject addAction [
    localize "STR_ROOT_DRONEFEED_ACTION_TAKE_CONTROL",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments params ["_feedData"];

        if (!([_caller, _feedData] call Root_fnc_checkAccess)) exitWith {
            hint parseText format ["<t color='%1'>%2</t>", COLOR_ERROR, localize "STR_ROOT_DRONEFEED_NO_ACCESS"];
        };

        [_caller, _feedData] call Root_fnc_requestControl;
    },
    [_feedData],
    1.5,
    true,
    true,
    "",
    "true",
    15
];

_screenObject addAction [
    localize "STR_ROOT_DRONEFEED_ACTION_RELEASE_CONTROL",
    {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _arguments params ["_feedData"];

        private _controller = _feedData get "currentController";
        if (_controller isNotEqualTo _caller) exitWith {
            hint parseText format ["<t color='%1'>%2</t>", COLOR_ERROR, "You are not controlling this feed"];
        };

        [_caller, _feedData] call Root_fnc_releaseControl;
    },
    [_feedData],
    1.5,
    false,
    true,
    "",
    "true",
    15
];

if (_feedMode isEqualTo FEED_MODE_SATELLITE) then {
    _screenObject addAction [
        localize "STR_ROOT_DRONEFEED_ACTION_OPEN_MAP",
        {
            params ["_target", "_caller", "_actionId", "_arguments"];
            _arguments params ["_feedData"];

            private _controller = _feedData get "currentController";
            if (_controller isNotEqualTo _caller) exitWith {
                hint parseText format ["<t color='%1'>%2</t>", COLOR_ERROR, "You must take control first"];
            };

            [_caller, _feedData] call Root_fnc_openMapControl;
        },
        [_feedData],
        1.5,
        false,
        true,
        "",
        "true",
        15
    ];
};

for "_i" from 1 to 6 do {
    _screenObject addAction [
        format [localize "STR_ROOT_DRONEFEED_ACTION_ZOOM", _i],
        {
            params ["_target", "_caller", "_actionId", "_arguments"];
            _arguments params ["_feedData", "_zoomLevel"];

            private _controller = _feedData get "currentController";
            if (_controller isNotEqualTo _caller) exitWith {
                hint parseText format ["<t color='%1'>%2</t>", COLOR_ERROR, "You must take control first"];
            };

            [_feedData, _zoomLevel] call Root_fnc_setZoom;
        },
        [_feedData, _i],
        1.5,
        false,
        true,
        "",
        "true",
        15
    ];
};

private _visionModes = ["Normal", "Night Vision", "Thermal"];
for "_i" from 0 to 2 do {
    _screenObject addAction [
        format [localize "STR_ROOT_DRONEFEED_ACTION_VISION", _visionModes select _i],
        {
            params ["_target", "_caller", "_actionId", "_arguments"];
            _arguments params ["_feedData", "_visionMode"];

            private _controller = _feedData get "currentController";
            if (_controller isNotEqualTo _caller) exitWith {
                hint parseText format ["<t color='%1'>%2</t>", COLOR_ERROR, "You must take control first"];
            };

            [_feedData, _visionMode] call Root_fnc_setVision;
        },
        [_feedData, _i],
        1.5,
        false,
        true,
        "",
        "true",
        15
    ];
};

systemChat format ["ROOT DRONEFEED: Actions added for feed %1 on screen %2", _feedData get "feedId", typeOf _screenObject];
LOG_DEBUG_1("Control actions added for feed %1",_feedData get "feedId");

#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Request control of a feed
 *
 * Arguments:
 * 0: _player <OBJECT> - Player requesting control
 * 1: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * <BOOLEAN> - True if control was granted or queued
 *
 * Example:
 * [player, _feedData] call Root_fnc_requestControl;
 *
 * Public: No
 */

params [
    ["_player", objNull, [objNull]],
    ["_feedData", createHashMap, [createHashMap]]
];

if (isNull _player) exitWith {false};

private _feedId = _feedData get "feedId";

if !([_player, _feedData] call FUNC(checkAccess)) exitWith {
    hint parseText format ["<t color='%1'>%2</t>", COLOR_ERROR, localize "STR_ROOT_DRONEFEED_NO_ACCESS"];
    false
};

private _currentController = _feedData get "currentController";
private _controlQueue = _feedData get "controlQueue";

if (isNull _currentController) then {
    [_feedId, _player] call FUNC(grantControl);
    true
} else {
    if (_currentController isEqualTo _player) exitWith {
        hint parseText format ["<t color='%1'>%2</t>", COLOR_INFO, localize "STR_ROOT_DRONEFEED_ALREADY_CONTROLLING"];
        true
    };
    
    if (_player in _controlQueue) exitWith {
        hint parseText format ["<t color='%1'>%2</t>", COLOR_WARNING, localize "STR_ROOT_DRONEFEED_ALREADY_QUEUED"];
        true
    };
    
    private _multiControl = missionNamespace getVariable [SETTING_MULTI_CONTROL, false];
    if (_multiControl) then {
        [_feedId, _player] call FUNC(grantControl);
        true
    } else {
        _controlQueue pushBack _player;
        _feedData set ["controlQueue", _controlQueue];
        
        [EVENT_CONTROL_REQUESTED, [_feedId, _player]] call CBA_fnc_globalEvent;
        
        hint parseText format ["<t color='%1'>%2</t>", COLOR_INFO, localize "STR_ROOT_DRONEFEED_QUEUED"];
        true
    };
};

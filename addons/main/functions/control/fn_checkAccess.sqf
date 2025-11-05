#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Check if a player has access to control a feed
 *
 * Arguments:
 * 0: _player <OBJECT> - Player to check
 * 1: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * <BOOLEAN> - True if player has access
 *
 * Example:
 * [player, _feedData] call Root_fnc_checkAccess;
 *
 * Public: No
 */

params [
    ["_player", objNull, [objNull]],
    ["_feedData", createHashMap, [createHashMap]]
];

if (isNull _player) exitWith {false};

private _authorizedUsers = _feedData get "authorizedUsers";
private _activationRadius = _feedData get "activationRadius";
private _screenObject = _feedData get "screenObject";

if (_activationRadius > 0 && {!isNull _screenObject}) then {
    if ((_player distance _screenObject) > _activationRadius) exitWith {
        false
    };
};

private _hasAccess = false;
{
    if (_x isEqualType sideUnknown) then {
        if (side _player isEqualTo _x) then {
            _hasAccess = true;
        };
    } else {
        if (_x isEqualType grpNull) then {
            if (group _player isEqualTo _x) then {
                _hasAccess = true;
            };
        } else {
            if (_player isEqualTo _x) then {
                _hasAccess = true;
            };
        };
    };
} forEach _authorizedUsers;

_hasAccess

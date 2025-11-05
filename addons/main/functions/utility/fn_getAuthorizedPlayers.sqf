#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Get all players authorized to control a feed
 *
 * Arguments:
 * 0: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * <ARRAY> - Array of player objects
 *
 * Example:
 * private _players = [_feedData] call Root_fnc_getAuthorizedPlayers;
 *
 * Public: No
 */

params [
    ["_feedData", createHashMap, [createHashMap]]
];

private _authorizedUsers = _feedData get "authorizedUsers";
private _players = [];

{
    private _authorizedEntry = _x;
    if (_authorizedEntry isEqualType sideUnknown) then {
        {
            if (isPlayer _x && {side _x isEqualTo _authorizedEntry}) then {
                _players pushBackUnique _x;
            };
        } forEach allUnits;
    } else {
        if (_authorizedEntry isEqualType grpNull) then {
            {
                if (isPlayer _x && {group _x isEqualTo _authorizedEntry}) then {
                    _players pushBackUnique _x;
                };
            } forEach allUnits;
        } else {
            if (isPlayer _authorizedEntry) then {
                _players pushBackUnique _authorizedEntry;
            };
        };
    };
} forEach _authorizedUsers;

_players

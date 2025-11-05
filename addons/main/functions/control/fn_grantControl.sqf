#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Grant control of a feed to a player
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID
 * 1: _player <OBJECT> - Player to grant control to
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * ["feed_1_1234", player] call Root_fnc_grantControl;
 *
 * Public: No
 */

if (!isServer) exitWith {
    [_this, QFUNC(grantControl)] call CBA_fnc_serverEvent;
    true
};

params [
    ["_feedId", "", [""]],
    ["_player", objNull, [objNull]]
];

if (_feedId isEqualTo "" || isNull _player) exitWith {false};

private _feedData = [_feedId] call FUNC(getFeedData);

if (isNil "_feedData") exitWith {false};

_feedData set ["currentController", _player];

private _changes = createHashMap;
_changes set ["currentController", _player];
[_feedId, _changes] call FUNC(modifyFeed);

[EVENT_CONTROL_GRANTED, [_feedId, _player]] call CBA_fnc_globalEvent;

LOG_DEBUG_2("Control granted to %1 for feed %2",name _player,_feedId);

true

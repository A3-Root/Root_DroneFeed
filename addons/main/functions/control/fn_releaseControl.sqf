#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Release control of a feed
 *
 * Arguments:
 * 0: _player <OBJECT> - Player releasing control
 * 1: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * [player, _feedData] call Root_fnc_releaseControl;
 *
 * Public: No
 */

params [
    ["_player", objNull, [objNull]],
    ["_feedData", createHashMap, [createHashMap]]
];

if (isNull _player) exitWith {false};

private _feedId = _feedData get "feedId";
private _currentController = _feedData get "currentController";

if (_currentController != _player) exitWith {
    hint parseText format ["<t color='%1'>%2</t>", COLOR_ERROR, localize "STR_ROOT_DRONEFEED_NOT_CONTROLLING"];
    false
};

private _controlQueue = _feedData get "controlQueue";

if (count _controlQueue > 0) then {
    private _nextController = _controlQueue deleteAt 0;
    _feedData set ["controlQueue", _controlQueue];
    [_feedId, _nextController] call FUNC(grantControl);
} else {
    _feedData set ["currentController", objNull];
    
    if (isServer) then {
        private _changes = createHashMap;
        _changes set ["currentController", objNull];
        [_feedId, _changes] call FUNC(modifyFeed);
    } else {
        [_feedId, objNull] remoteExec [QFUNC(grantControl), 2];
    };
};

[EVENT_CONTROL_RELEASED, [_feedId, _player]] call CBA_fnc_globalEvent;

hint parseText format ["<t color='%1'>%2</t>", COLOR_INFO, localize "STR_ROOT_DRONEFEED_CONTROL_RELEASED"];

LOG_DEBUG_2("Control released by %1 for feed %2",name _player,_feedId);

true

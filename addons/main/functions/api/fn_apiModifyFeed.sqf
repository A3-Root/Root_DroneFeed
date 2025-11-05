#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Public API to modify an existing feed
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID to modify
 * 1: _changes <HASHMAP> - Hashmap of changes to apply
 *                         Supported keys: authorizedUsers, activationRadius, altitude, droneObject
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * private _changes = createHashMap;
 * _changes set ["activationRadius", 250];
 * _changes set ["authorizedUsers", [west, east]];
 * ["feed_1_1234", _changes] call Root_fnc_apiModifyFeed;
 *
 * Public: Yes
 */

params [
    ["_feedId", "", [""]],
    ["_changes", createHashMap, [createHashMap]]
];

if (!isServer) exitWith {
    private _result = [_feedId, _changes] remoteExecCall [QFUNC(apiModifyFeed), 2];
    _result
};

[_feedId, _changes] call FUNC(modifyFeed)

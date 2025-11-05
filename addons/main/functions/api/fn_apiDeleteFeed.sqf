#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Public API to delete a feed
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID to delete
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * ["feed_1_1234"] call Root_fnc_apiDeleteFeed;
 *
 * Public: Yes
 */

params [
    ["_feedId", "", [""]]
];

if (!isServer) exitWith {
    private _result = [_feedId] remoteExecCall [QFUNC(apiDeleteFeed), 2];
    _result
};

[_feedId] call FUNC(deleteFeed)

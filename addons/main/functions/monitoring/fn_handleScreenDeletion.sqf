#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Handle screen object deletion
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID
 * 1: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * None
 *
 * Example:
 * ["feed_1_1234", _feedData] call Root_fnc_handleScreenDeletion;
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_feedId", "", [""]],
    ["_feedData", createHashMap, [createHashMap]]
];

private _createdBy = _feedData get "createdBy";

LOG_INFO_1("Screen destroyed for feed %1",_feedId);

private _msg = format [localize "STR_ROOT_DRONEFEED_SCREEN_DESTROYED", _feedId];
[_createdBy, _msg] call FUNC(notifyAdmin);

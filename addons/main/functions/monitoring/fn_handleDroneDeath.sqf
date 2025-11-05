#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Handle drone death by terminating associated feeds
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID
 * 1: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * None
 *
 * Example:
 * ["feed_1_1234", _feedData] call Root_fnc_handleDroneDeath;
 *
 * Public: No
 */

if (!isServer) exitWith {};

params [
    ["_feedId", "", [""]],
    ["_feedData", createHashMap, [createHashMap]]
];

private _createdBy = _feedData get "createdBy";

LOG_INFO_1("Drone destroyed for feed %1, terminating feed",_feedId);

private _msg = format [localize "STR_ROOT_DRONEFEED_DRONE_DESTROYED", _feedId];
[_createdBy, _msg] call FUNC(notifyAdmin);

private _authorizedPlayers = [_feedData] call FUNC(getAuthorizedPlayers);
{
    if (isPlayer _x) then {
        private _notification = format ["<t color='%1'>%2</t>", COLOR_ERROR, localize "STR_ROOT_DRONEFEED_FEED_TERMINATED_DRONE"];
        [_notification, _x] remoteExec ["hint", _x];
    };
} forEach _authorizedPlayers;

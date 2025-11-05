#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Link a drone to a feed (used when modifying feeds)
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID
 * 1: _drone <OBJECT> - Drone object to link
 *
 * Return Value:
 * <BOOLEAN> - True if successful
 *
 * Example:
 * ["feed_1_1234", _myDrone] call Root_fnc_linkDroneToFeed;
 *
 * Public: No
 */

if (!isServer) exitWith {
    LOG_ERROR("linkDroneToFeed must be called on server");
    false
};

params [
    ["_feedId", "", [""]],
    ["_drone", objNull, [objNull]]
];

if (_feedId isEqualTo "") exitWith {
    LOG_ERROR("linkDroneToFeed: Invalid feed ID");
    false
};

if (isNull _drone) exitWith {
    LOG_ERROR("linkDroneToFeed: Invalid drone");
    false
};

private _changes = createHashMap;
_changes set ["droneObject", _drone];
_changes set ["feedMode", FEED_MODE_DRONE];

[_feedId, _changes] call FUNC(modifyFeed);

LOG_INFO_2("Drone linked to feed: %1 -> %2",_feedId,typeOf _drone);

true

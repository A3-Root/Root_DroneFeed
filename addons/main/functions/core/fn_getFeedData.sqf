#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Get feed data for a specific feed ID
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID
 *
 * Return Value:
 * <HASHMAP> - Feed data, or nil if not found
 *
 * Example:
 * private _feedData = ["feed_1_1234"] call Root_fnc_getFeedData;
 *
 * Public: No
 */

params [
    ["_feedId", "", [""]]
];

if (_feedId isEqualTo "") exitWith {
    LOG_ERROR("getFeedData: Invalid feed ID");
    nil
};

if (hasInterface) then {
    private _clientFeeds = GET_CLIENT_FEEDS;
    private _feedData = _clientFeeds get _feedId;

    if (!isNil "_feedData") exitWith {
        _feedData
    };
};

private _registry = call FUNC(getRegistry);
private _feedData = _registry get _feedId;

if (isNil "_feedData") then {
    LOG_DEBUG_1("Feed not found: %1",_feedId);
    nil
} else {
    _feedData
};

#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Delete an existing feed
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID to delete
 *
 * Return Value:
 * <BOOLEAN> - True if successful, false if failed
 *
 * Example:
 * ["feed_1_1234"] call Root_fnc_deleteFeed;
 *
 * Public: No
 */

if (!isServer) exitWith {
    LOG_ERROR("deleteFeed must be called on server");
    false
};

params [
    ["_feedId", "", [""]]
];

if (_feedId isEqualTo "") exitWith {
    LOG_ERROR("deleteFeed: Invalid feed ID");
    false
};

private _feedData = [_feedId] call FUNC(getFeedData);

if (isNil "_feedData") exitWith {
    LOG_ERROR_1("deleteFeed: Feed not found: %1",_feedId);
    false
};

private _screenObject = _feedData get "screenObject";
if (!isNull _screenObject) then {
    _screenObject setVariable ["ROOT_DRONEFEED_FEED_ID", nil, true];
    _screenObject setVariable ["ROOT_DRONEFEED_FEED_DATA", nil, true];
    _screenObject setObjectTexture [_feedData get "screenTextureId", ""];
};

private _registry = call FUNC(getRegistry);
_registry deleteAt _feedId;
missionNamespace setVariable [GVAR_REGISTRY, _registry, true];

[EVENT_FEED_DELETED, [_feedId]] call CBA_fnc_globalEvent;

LOG_INFO_1("Feed deleted: %1",_feedId);

true

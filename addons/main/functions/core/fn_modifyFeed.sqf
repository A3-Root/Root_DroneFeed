#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Modify an existing feed's configuration
 *
 * Arguments:
 * 0: _feedId <STRING> - Feed ID to modify
 * 1: _changes <HASHMAP> - Hashmap of changes to apply
 *
 * Return Value:
 * <BOOLEAN> - True if successful, false if failed
 *
 * Example:
 * private _changes = createHashMap;
 * _changes set ["activationRadius", 200];
 * ["feed_1_1234", _changes] call Root_fnc_modifyFeed;
 *
 * Public: No
 */

if (!isServer) exitWith {
    LOG_ERROR("modifyFeed must be called on server");
    false
};

params [
    ["_feedId", "", [""]],
    ["_changes", createHashMap, [createHashMap]]
];

if (_feedId isEqualTo "") exitWith {
    LOG_ERROR("modifyFeed: Invalid feed ID");
    false
};

private _feedData = [_feedId] call FUNC(getFeedData);

if (isNil "_feedData") exitWith {
    LOG_ERROR_1("modifyFeed: Feed not found: %1",_feedId);
    false
};

{
    private _key = _x;
    private _value = _y;
    
    if (_key in ["feedId", "screenObject", "rttIdentifier", "createdBy", "cameraObject"]) then {
        LOG_ERROR_1("modifyFeed: Cannot modify protected field: %1",_key);
    } else {
        _feedData set [_key, _value];
        LOG_DEBUG_3("Modified feed %1: %2 = %3",_feedId,_key,_value);
    };
} forEach _changes;

private _screenObject = _feedData get "screenObject";
if (!isNull _screenObject) then {
    _screenObject setVariable ["ROOT_DRONEFEED_FEED_DATA", _feedData, true];
};

private _registry = call FUNC(getRegistry);
_registry set [_feedId, _feedData];
missionNamespace setVariable [GVAR_REGISTRY, _registry, true];

[EVENT_FEED_MODIFIED, [_feedId, _changes]] call CBA_fnc_globalEvent;

LOG_INFO_1("Feed modified: %1",_feedId);

true

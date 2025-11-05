#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Generate a unique feed ID
 *
 * Arguments: None
 *
 * Return Value:
 * <STRING> - Unique feed ID
 *
 * Example:
 * private _feedId = [] call Root_fnc_generateFeedId;
 *
 * Public: No
 */

if (!isServer) exitWith {
    LOG_ERROR("generateFeedId must be called on server");
    ""
};

private _counter = missionNamespace getVariable [GVAR_FEED_COUNTER, 0];
_counter = _counter + 1;
missionNamespace setVariable [GVAR_FEED_COUNTER, _counter, true];

private _feedId = format ["feed_%1_%2", _counter, floor(time)];
LOG_DEBUG_1("Generated feed ID: %1",_feedId);

_feedId

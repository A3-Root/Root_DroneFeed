#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Create a new drone/satellite feed
 *
 * Arguments:
 * 0: _screenObject <OBJECT> - Screen object to project feed onto
 * 1: _textureId <NUMBER> - Texture ID on screen object (default: 0)
 * 2: _authorizedUsers <ARRAY> - Array of authorized units/groups/sides
 * 3: _feedMode <STRING> - Feed mode ("DRONE" or "SATELLITE")
 * 4: _droneOrAltitude <OBJECT|NUMBER> - Drone object or satellite altitude
 * 5: _activationRadius <NUMBER> (Optional) - Activation radius in meters (default: from settings)
 * 6: _curator <OBJECT> (Optional) - Curator who created the feed
 *
 * Return Value:
 * <STRING> - Feed ID if successful, empty string if failed
 *
 * Example:
 * [_screen, 0, [player], "SATELLITE", 1000, 100] call Root_fnc_createFeed;
 *
 * Public: No
 */

if (!isServer) exitWith {
    LOG_ERROR("createFeed must be called on server");
    ""
};

LOG_DEBUG("createFeed: Starting feed creation on server");

params [
    ["_screenObject", objNull, [objNull]],
    ["_textureId", 0, [0]],
    ["_authorizedUsers", [], [[]]],
    ["_feedMode", "", [""]],
    ["_droneOrAltitude", objNull, [objNull, 0]],
    ["_activationRadius", missionNamespace getVariable [SETTING_DEFAULT_RADIUS, DEFAULT_ACTIVATION_RADIUS], [0]],
    ["_curator", objNull, [objNull]]
];

if (isNull _screenObject) exitWith {
    LOG_ERROR("createFeed: Invalid screen object");
    ""
};

if (!VALIDATE_FEED_MODE(_feedMode)) exitWith {
    LOG_ERROR_1("createFeed: Invalid feed mode: %1",_feedMode);
    ""
};

if (_authorizedUsers isEqualTo []) exitWith {
    LOG_ERROR("createFeed: No authorized users specified");
    ""
};

private _feedId = call FUNC(generateFeedId);
private _rttIdentifier = format ["rtt_%1", _feedId];

LOG_DEBUG_2("createFeed: Generated feed ID %1 with RTT %2",_feedId,_rttIdentifier);

private _feedData = createHashMap;
_feedData set ["feedId", _feedId];
_feedData set ["screenObject", _screenObject];
_feedData set ["screenTextureId", _textureId];
_feedData set ["feedMode", _feedMode];
_feedData set ["authorizedUsers", _authorizedUsers];
_feedData set ["activationRadius", _activationRadius];
_feedData set ["currentController", objNull];
_feedData set ["controlQueue", []];
_feedData set ["rttIdentifier", _rttIdentifier];
_feedData set ["createdBy", _curator];
_feedData set ["cameraObject", objNull];

LOG_DEBUG_4("createFeed: Feed data hashmap created - mode %1, screen %2, textureId %3, authUsers %4",_feedMode,_screenObject,_textureId,_authorizedUsers);

if (_feedMode isEqualTo FEED_MODE_DRONE) then {
    if (isNull _droneOrAltitude) exitWith {
        LOG_ERROR("createFeed: Invalid drone object for DRONE mode");
        _feedId = "";
    };
    _feedData set ["droneObject", _droneOrAltitude];
    _feedData set ["altitude", 0];
    LOG_DEBUG_2("createFeed: DRONE mode - drone object %1 set for feed %2",_droneOrAltitude,_feedId);
} else {
    if (_droneOrAltitude isEqualType objNull) exitWith {
        LOG_ERROR("createFeed: Expected altitude number for SATELLITE mode");
        _feedId = "";
    };
    _feedData set ["droneObject", objNull];
    _feedData set ["altitude", _droneOrAltitude];
    LOG_DEBUG_2("createFeed: SATELLITE mode - altitude %1 set for feed %2",_droneOrAltitude,_feedId);
};

if (_feedId isEqualTo "") exitWith {
    LOG_ERROR("createFeed: Feed ID empty after mode check, aborting");
    ""
};

_screenObject setVariable ["ROOT_DRONEFEED_FEED_ID", _feedId, true];
_screenObject setVariable ["ROOT_DRONEFEED_FEED_DATA", _feedData, true];

LOG_DEBUG_2("createFeed: Screen variables set on %1 for feed %2",_screenObject,_feedId);

private _registry = call FUNC(getRegistry);
_registry set [_feedId, _feedData];
missionNamespace setVariable [GVAR_REGISTRY, _registry, true];

LOG_DEBUG_2("createFeed: Feed %1 added to registry, total feeds: %2",_feedId,count _registry);

[EVENT_FEED_CREATED, [_feedData]] call CBA_fnc_globalEvent;

LOG_INFO_2("Feed created: %1, Mode: %2",_feedId,_feedMode);
LOG_DEBUG_1("createFeed: Global event EVENT_FEED_CREATED fired for %1",_feedId);

_feedId

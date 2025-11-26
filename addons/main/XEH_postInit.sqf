#include "script_component.hpp"
/*
 * Author: Root
 * Description: CBA PostInit Event Handler
 *              Executes after mission objects are created but before mission starts
 *
 * Responsibilities:
 * - Register CBA event handlers for network communication
 * - Initialize data structures
 * - Start monitoring systems
 *
 * Execution Order: PreInit -> PostInit -> Mission Objects Created -> Mission Start
 *
 * Public: No
 */

if (isServer) then {
    private _registry = createHashMap;
    missionNamespace setVariable [GVAR_REGISTRY, _registry, true];
    
    missionNamespace setVariable [GVAR_FEED_COUNTER, 0, true];
    
    [EVENT_FEED_CREATED, {
        params ["_feedData"];
        LOG_DEBUG_1("Feed created: %1",_feedData get "feedId");
    }] call CBA_fnc_addEventHandler;
    
    [EVENT_FEED_DELETED, {
        params ["_feedId"];
        LOG_DEBUG_1("Feed deleted: %1",_feedId);
    }] call CBA_fnc_addEventHandler;
    
    [EVENT_FEED_MODIFIED, {
        params ["_feedId", "_changes"];
        LOG_DEBUG_2("Feed modified: %1, Changes: %2",_feedId,_changes);
    }] call CBA_fnc_addEventHandler;
    
    [] call FUNC(monitorFeeds);
};

if (hasInterface) then {
    private _clientFeeds = createHashMap;
    missionNamespace setVariable [GVAR_CLIENT_FEEDS, _clientFeeds, false];
    LOG_DEBUG("Client feeds hashmap initialized");

    [EVENT_FEED_CREATED, {
        params ["_feedData"];

        private _feedId = _feedData get "feedId";
        private _feedMode = _feedData get "feedMode";
        private _screenObject = _feedData get "screenObject";

        LOG_DEBUG_4("EVENT_FEED_CREATED: Received for feed %1, mode %2, screen %3, data %4",_feedId,_feedMode,_screenObject,_feedData);

        [_feedData] call FUNC(createCamera);
        [player, _feedData] call FUNC(addControlActions);

        LOG_DEBUG_1("EVENT_FEED_CREATED: Camera and control actions created for %1",_feedId);
    }] call CBA_fnc_addEventHandler;

    [EVENT_FEED_DELETED, {
        params ["_feedId"];
        private _feedData = [_feedId] call FUNC(getFeedData);

        if (!isNil "_feedData" && {!isNull (_feedData get "cameraObject")}) then {
            [_feedData] call FUNC(destroyCamera);
        };
    }] call CBA_fnc_addEventHandler;

    [EVENT_CONTROL_GRANTED, {
        params ["_feedId", "_controller"];

        if (_controller isEqualTo player) then {
            private _msg = format ["<t color='%1'>%2</t>", COLOR_SUCCESS, localize "STR_ROOT_DRONEFEED_CONTROL_GRANTED"];
            hint parseText _msg;
        };
    }] call CBA_fnc_addEventHandler;

    [EVENT_CONTROL_REQUESTED, {
        params ["_feedId", "_requester"];
        private _feedData = [_feedId] call FUNC(getFeedData);

        if (!isNil "_feedData" && {(_feedData get "currentController") isEqualTo player}) then {
            private _msg = format [localize "STR_ROOT_DRONEFEED_CONTROL_REQUEST", name _requester];
            hint parseText format ["<t color='%1'>%2</t>", COLOR_WARNING, _msg];
        };
    }] call CBA_fnc_addEventHandler;

    [EVENT_CAMERA_ZOOM, {
        params ["_feedId", "_zoomLevel"];
        private _feedData = [_feedId] call FUNC(getFeedData);

        if (!isNil "_feedData") then {
            private _camera = _feedData get "cameraObject";
            if (!isNull _camera) then {
                private _fov = DEFAULT_CAMERA_FOV;
                if (_zoomLevel >= 1 && {_zoomLevel <= 6}) then {
                    switch (_zoomLevel) do {
                        case 1: {_fov = ZOOM_LEVEL_1};
                        case 2: {_fov = ZOOM_LEVEL_2};
                        case 3: {_fov = ZOOM_LEVEL_3};
                        case 4: {_fov = ZOOM_LEVEL_4};
                        case 5: {_fov = ZOOM_LEVEL_5};
                        case 6: {_fov = ZOOM_LEVEL_6};
                    };
                } else {
                    _fov = _zoomLevel;
                };
                _camera camSetFov _fov;
                _camera camCommit 0;
            };
        };
    }] call CBA_fnc_addEventHandler;

    [EVENT_CAMERA_VISION, {
        params ["_feedId", "_visionMode"];
        private _feedData = [_feedId] call FUNC(getFeedData);

        if (!isNil "_feedData") then {
            private _rttIdentifier = _feedData get "rttIdentifier";
            if (!isNil "_rttIdentifier") then {
                _rttIdentifier setPiPEffect [_visionMode];
            };
        };
    }] call CBA_fnc_addEventHandler;

};

LOG_INFO("Post-init complete");

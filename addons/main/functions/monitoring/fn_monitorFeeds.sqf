#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Monitor all feeds for validity (drone death, screen deletion)
 *              Runs continuously on server
 *
 * Arguments: None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call Root_fnc_monitorFeeds;
 *
 * Public: No
 */

if (!isServer) exitWith {};

[{
    private _registry = call FUNC(getRegistry);
    private _feedsToDelete = [];
    
    {
        private _feedId = _x;
        private _feedData = _y;
        
        private _screenObject = _feedData get "screenObject";
        private _feedMode = _feedData get "feedMode";
        
        if (isNull _screenObject || !alive _screenObject) then {
            [_feedId, _feedData] call FUNC(handleScreenDeletion);
            _feedsToDelete pushBack _feedId;
        } else {
            if (_feedMode isEqualTo FEED_MODE_DRONE) then {
                private _drone = _feedData get "droneObject";
                if (isNull _drone || !alive _drone) then {
                    [_feedId, _feedData] call FUNC(handleDroneDeath);
                    _feedsToDelete pushBack _feedId;
                };
            };
        };
    } forEach _registry;
    
    {
        [_x] call FUNC(deleteFeed);
    } forEach _feedsToDelete;
    
}, 5] call CBA_fnc_addPerFrameHandler;

LOG_INFO("Feed monitoring started");

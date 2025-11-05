#include "\z\root_dronefeed\addons\main\script_component.hpp"
params [["_curator", objNull]];

private _registry = call FUNC(getRegistry);
private _feedIds = [];
private _feedNames = [];

{
    private _feedId = _x;
    private _feedData = _y;
    private _screenObj = _feedData get "screenObject";
    private _feedMode = _feedData get "feedMode";
    
    _feedIds pushBack _feedId;
    _feedNames pushBack format ["%1 (%2) - %3", typeOf _screenObj, _feedId, _feedMode];
} forEach _registry;

if (count _feedIds isEqualTo 0) exitWith {
    [localize "STR_ROOT_DRONEFEED_NO_FEEDS"] call zen_common_fnc_showMessage;
};

[
    localize "STR_ROOT_DRONEFEED_ZEUS_MODIFY_TITLE",
    [
        ["COMBO", localize "STR_ROOT_DRONEFEED_SELECT_FEED", [_feedIds, _feedNames, 0]],
        ["OWNERS", localize "STR_ROOT_DRONEFEED_NEW_AUTHORIZED_USERS", [[],[],[]]],
        ["SLIDER", localize "STR_ROOT_DRONEFEED_NEW_RADIUS", [0, 1000, 100, 0]]
    ],
    {
        params ["_results", "_args"];
        _results params ["_feedId", "_owners", "_newRadius"];
        
        private _changes = createHashMap;
        
        private _authorizedUsers = _owners select 0;
        _authorizedUsers append (_owners select 1);
        _authorizedUsers append (_owners select 2);
        
        if (count _authorizedUsers > 0) then {
            _changes set ["authorizedUsers", _authorizedUsers];
        };
        
        _changes set ["activationRadius", _newRadius];
        
        [_feedId, _changes] remoteExec [QFUNC(modifyFeed), 2];
        [localize "STR_ROOT_DRONEFEED_FEED_MODIFIED"] call zen_common_fnc_showMessage;
    },
    {},
    []
] call zen_dialog_fnc_create;

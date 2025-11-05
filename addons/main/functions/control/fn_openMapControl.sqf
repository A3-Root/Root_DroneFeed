#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Open map for satellite feed position control
 *
 * Arguments:
 * 0: _player <OBJECT> - Player opening map
 * 1: _feedData <HASHMAP> - Feed data
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, _feedData] call Root_fnc_openMapControl;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

params [
    ["_player", objNull, [objNull]],
    ["_feedData", createHashMap, [createHashMap]]
];

if (isNull _player) exitWith {};

private _feedId = _feedData get "feedId";
systemChat format ["DEBUG: openMapControl called for feedId=%1", _feedId];

openMap true;

private _mapClickId = format ["ROOT_DRONEFEED_MAPCLICK_%1", _feedId];
systemChat format ["DEBUG: Registering map click handler with id=%1", _mapClickId];

[_mapClickId, "onMapSingleClick", {
    params ["_units", "_pos", "_alt", "_shift"];
    _thisArgs params ["_feedId"];

    systemChat format ["DEBUG: Map clicked! feedId=%1, pos=%2", _feedId, _pos];

    private _feedData = [_feedId] call Root_fnc_getFeedData;
    systemChat format ["DEBUG: getFeedData returned: %1", if (isNil "_feedData") then {"nil"} else {str _feedData}];

    if (isNil "_feedData") then {
        systemChat "DEBUG: feedData is nil, cannot handle map click";
    } else {
        [_feedData, _pos] call Root_fnc_handleMapClick;
        hint parseText format ["<t color='%1'>%2</t>", COLOR_SUCCESS, localize "STR_ROOT_DRONEFEED_POSITION_UPDATED"];
    };

}, [_feedId]] call BIS_fnc_addStackedEventHandler;
systemChat "DEBUG: Map click handler registered successfully";

[{
    params ["_args"];
    _args params ["_mapClickId"];
    
    if (!visibleMap) exitWith {
        [_mapClickId, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
        true
    };
    false
}, {}, [_mapClickId], 300, {
    params ["_args"];
    _args params ["_mapClickId"];
    [_mapClickId, "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
}] call CBA_fnc_waitUntilAndExecute;

LOG_DEBUG_1("Map control opened for feed %1",_feedId);

#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Get list of all available UAVs in the mission
 *
 * Arguments: None
 *
 * Return Value:
 * <ARRAY> - Array of [drone, displayName] pairs
 *
 * Example:
 * private _drones = [] call Root_fnc_getDroneList;
 *
 * Public: No
 */

private _droneList = [];

{
    if (unitIsUAV _x && {alive _x}) then {
        private _displayName = getText (configOf _x >> "displayName");
        if (_displayName isEqualTo "") then {
            _displayName = typeOf _x;
        };
        _displayName = format ["%1 (%2m)", _displayName, round((getPosATL _x) select 2)];
        _droneList pushBack [_x, _displayName];
    };
} forEach vehicles;

LOG_DEBUG_1("Found %1 drones",count _droneList);

_droneList

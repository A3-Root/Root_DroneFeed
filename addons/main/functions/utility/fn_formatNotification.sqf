#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Format a colored notification message
 *
 * Arguments:
 * 0: _message <STRING> - Message text or stringtable key
 * 1: _color <STRING> (Optional) - Color code (default: COLOR_INFO)
 *
 * Return Value:
 * <STRING> - Formatted HTML text
 *
 * Example:
 * private _msg = ["Feed created", COLOR_SUCCESS] call Root_fnc_formatNotification;
 *
 * Public: No
 */

params [
    ["_message", "", [""]],
    ["_color", COLOR_INFO, [""]]
];

if (_message isEqualTo "") exitWith {""};

format ["<t color='%1'>%2</t>", _color, _message]

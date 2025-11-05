#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Notify Zeus curator or admin about feed events
 *
 * Arguments:
 * 0: _curator <OBJECT> - Curator to notify (can be objNull for all curators)
 * 1: _message <STRING> - Message to send
 *
 * Return Value:
 * None
 *
 * Example:
 * [curatorObj, "Feed screen was destroyed"] call Root_fnc_notifyAdmin;
 *
 * Public: No
 */

params [
    ["_curator", objNull, [objNull]],
    ["_message", "", [""]]
];

if (_message isEqualTo "") exitWith {};

private _notifyMethod = missionNamespace getVariable [SETTING_ADMIN_NOTIFY, "hint"];

if (_notifyMethod isEqualTo "none") exitWith {};

private _curators = [];
if (isNull _curator) then {
    _curators = allCurators;
} else {
    _curators = [_curator];
};

{
    private _curatorPlayer = getAssignedCuratorUnit _x;
    if (!isNull _curatorPlayer && isPlayer _curatorPlayer) then {
        private _formattedMsg = format ["<t color='%1'>[ROOT DroneFeed]</t><br/>%2", COLOR_INFO, _message];
        
        switch (_notifyMethod) do {
            case "hint": {
                [parseText _formattedMsg] remoteExec ["hint", _curatorPlayer];
            };
            case "systemChat": {
                [format ["[ROOT DroneFeed] %1", _message]] remoteExec ["systemChat", _curatorPlayer];
            };
        };
    };
} forEach _curators;

LOG_DEBUG_1("Admin notified: %1",_message);

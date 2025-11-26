#include "..\script_component.hpp"

params ["_requester"];

["syncClient start", format ["requester=%1", _requester]] call FUNC(debugLog);

private _screens = missionNamespace getVariable [QGVAR(screens), []];
private _target = owner _requester;
if (isNil "remoteExecutedOwner") then {
    // keep unit owner
} else {
    _target = remoteExecutedOwner;
};
if (isNull _requester) then {
    _target = 0;
};

[_screens] remoteExec ["root_dronefeed_fnc_updateScreens", _target, false];

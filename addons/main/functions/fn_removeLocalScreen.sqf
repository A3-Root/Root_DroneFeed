#include "..\script_component.hpp"

params ["_screenId"];

["removeLocalScreen start", format ["screenId=%1", _screenId]] call FUNC(debugLog);

private _states = missionNamespace getVariable [QGVAR(localScreenStates), []];
private _index = _states findIf {(_x select 0) isEqualTo _screenId};
if (_index == -1) exitWith {};

private _state = _states deleteAt _index;
missionNamespace setVariable [QGVAR(localScreenStates), _states, false];

_state params ["", "_screen", "", "", "_cam", "", "", "_actions", "_loopHandle"];

if (!isNull _cam) then {
    _cam cameraEffect ["terminate", "back"];
    camDestroy _cam;
};

{
    _screen removeAction _x;
} forEach _actions;

if !(isNil "_loopHandle") then {
    terminate _loopHandle;
};

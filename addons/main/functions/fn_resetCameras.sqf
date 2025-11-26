#include "..\script_component.hpp"

["resetCameras start", ""] call FUNC(debugLog);

private _states = missionNamespace getVariable [QGVAR(localScreenStates), []];
if (_states isEqualTo []) exitWith {};

{
    _x params ["_id", "", "", "_rtt", "_cam"];
    if (!isNull _cam) then {
        _cam cameraEffect ["Internal", "Back", _rtt];
        private _lastTarget = missionNamespace getVariable [format ["%1_%2", QGVAR(lastTarget), _id], []];
        if (_lastTarget isNotEqualTo []) then {
            _cam camSetTarget _lastTarget;
        };
        _cam camCommit 0;
    };
} forEach _states;

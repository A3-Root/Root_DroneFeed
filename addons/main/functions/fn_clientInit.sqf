#include "..\script_component.hpp"

if (!hasInterface) exitWith {};

["clientInit start", format ["player=%1", player]] call FUNC(debugLog);

if (isNil {missionNamespace getVariable QGVAR(localScreenStates)}) then {
    missionNamespace setVariable [QGVAR(localScreenStates), [], false];
};

if !(missionNamespace getVariable [QGVAR(playerHandlersRegistered), false]) then {
    private _registerEH = {
        params ["_event"];
        [_event, {
            private _fnc = missionNamespace getVariable ["root_dronefeed_fnc_resetCameras", {}];
            if (!isNil "_fnc") then {
                call _fnc;
            };
        }] call CBA_fnc_addPlayerEventHandler;
    };

    {
        [_x] call _registerEH;
    } forEach ["featureCamera", "cameraView", "unit", "visionMode"];
    missionNamespace setVariable [QGVAR(playerHandlersRegistered), true, false];
};

[player] remoteExec ["root_dronefeed_fnc_syncClient", 2];

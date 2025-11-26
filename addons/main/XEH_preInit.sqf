#include "script_component.hpp"

if (isNil {missionNamespace getVariable QGVAR(screens)}) then {
    missionNamespace setVariable [QGVAR(screens), [], true];
};
if (isNil {missionNamespace getVariable QGVAR(controllers)}) then {
    missionNamespace setVariable [QGVAR(controllers), [], true];
};
if (isNil {missionNamespace getVariable QGVAR(nextScreenId)}) then {
    missionNamespace setVariable [QGVAR(nextScreenId), 1, true];
};
if (isNil {missionNamespace getVariable QGVAR(terminalClasses)}) then {
    missionNamespace setVariable [QGVAR(terminalClasses), [
        "B_UavTerminal",
        "O_UavTerminal",
        "I_UavTerminal",
        "C_UavTerminal",
        "B_UavTerminal_tna_F",
        "B_UavTerminal_01_hex_F",
        "O_UavTerminal_tna_F",
        "O_UavTerminal_urb_F",
        "I_UavTerminal_01_F",
        "I_E_UavTerminal",
        "C_UavTerminal_01_F"
    ], false];
};

[
    QGVAR(defaultFoV),
    "SLIDER",
    ["Default Screen FoV", "Default zoom level for new feeds spawned via the module."],
    ["Roots Drone Feed", "General"],
    [0.05, 1, 0.4, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxScreens),
    "SLIDER",
    ["Maximum Screens", "Maximum number of Roots Drone Feed screens allowed simultaneously (0 disables limit)."],
    ["Roots Drone Feed", "General"],
    [0, 12, 6, 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowAnyDefault),
    "CHECKBOX",
    ["Allow any player", "If disabled, only Zeus (curators) may take drone control unless overridden per screen."],
    ["Roots Drone Feed", "General"],
    true,
    true
] call CBA_fnc_addSetting;

#define REGISTER_FNC(NAME) missionNamespace setVariable [QUOTE(root_dronefeed_fnc_##NAME), compile preprocessFileLineNumbers QPATHTOF(functions\fn_##NAME.sqf), true]

REGISTER_FNC(clientInit);
REGISTER_FNC(syncClient);
REGISTER_FNC(resetCameras);
REGISTER_FNC(getAimPos);
REGISTER_FNC(cameraLoop);
REGISTER_FNC(removeLocalScreen);
REGISTER_FNC(addActions);
REGISTER_FNC(updateScreens);
REGISTER_FNC(registerScreen);
REGISTER_FNC(removeScreen);
REGISTER_FNC(requestControl);
REGISTER_FNC(releaseControl);
REGISTER_FNC(setFov);
REGISTER_FNC(setVision);
REGISTER_FNC(grantControl);
REGISTER_FNC(onControlReleased);
REGISTER_FNC(notifyPlayer);

[] remoteExec ["root_dronefeed_fnc_clientInit", 0, true];
#undef REGISTER_FNC

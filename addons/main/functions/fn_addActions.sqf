#include "..\script_component.hpp"

params ["_screen", "_screenId", "_allowEveryone"];

private _actions = [];

_actions pushBack (_screen addAction [
    "Take Feed Control",
    {
        params ["", "_caller", "", "_args"];
        _args params ["_screenId"];
        [_screenId, _caller] remoteExec ["root_dronefeed_fnc_requestControl", 2];
    },
    [_screenId],
    1.5,
    true,
    true,
    "",
    "true",
    4,
    false,
    "",
    ""
]);

_actions pushBack (_screen addAction [
    "Release Feed Control",
    {
        params ["", "_caller", "", "_args"];
        _args params ["_screenId"];
        [_screenId, _caller] remoteExec ["root_dronefeed_fnc_releaseControl", 2];
    },
    [_screenId],
    1.5,
    true,
    true,
    "",
    "true",
    4,
    false,
    "",
    ""
]);

{
    private _display = _x;
    _actions pushBack (_screen addAction [
        format ["Set Live Feed FoV to %1", _display],
        {
            params ["", "_caller", "", "_args"];
            _args params ["_screenId", "_value"];
            [_screenId, _value] remoteExec ["root_dronefeed_fnc_setFov", 2];
        },
        [_screenId, _x],
        1.5,
        true,
        true,
        "",
        "true",
        4,
        false,
        "",
        ""
    ]);
} forEach [0.7, 0.4, 0.1, 0.07, 0.04, 0.01];

{
    _x params ["_mode", "_label"];
    _actions pushBack (_screen addAction [
        format ["Set Camera Effect: %1", _label],
        {
            params ["", "_caller", "", "_args"];
            _args params ["_screenId", "_mode"];
            [_screenId, _mode] remoteExec ["root_dronefeed_fnc_setVision", 2];
        },
        [_screenId, _mode],
        1.5,
        true,
        true,
        "",
        "true",
        4,
        false,
        "",
        ""
    ]);
} forEach [
    [0, "Normal"],
    [1, "Night Vision"],
    [2, "Thermal Vision"]
];

_actions

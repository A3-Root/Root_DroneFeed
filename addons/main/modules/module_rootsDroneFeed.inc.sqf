#include "..\script_component.hpp"

if (!hasInterface) exitWith {};

private _screenTypes = [
    ["Land_TripodScreen_01_large_F", "Large Tripod Screen"],
    ["Land_PortableScreen_01_video_F", "Portable Screen"],
    ["Land_Billboard_06_F", "Billboard"]
];

private _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa";

["Roots Drone Feed", "Create Feed Screen", {
    params ["_logic", "_object"];

    private _posATL = getPosATL _logic;
    deleteVehicle _logic;

    private _uavs = vehicles select {
        alive _x
        && {getNumber ((configOf _x) >> "isUav") == 1}
    };

    if (_uavs isEqualTo []) exitWith {
        ["No UAVs detected on the map."] call zen_common_fnc_showMessage;
    };

    private _uavData = _uavs apply {[netId _x, _x]};
    private _uavValues = _uavData apply {_x select 0};
    private _uavNames = _uavs apply {
        format ["%1 (%2)", getText ((configOf _x) >> "displayName"), mapGridPosition _x]
    };

    private _defaultFoV = missionNamespace getVariable [QGVAR(defaultFoV), 0.4];
    private _defaultAllowAll = missionNamespace getVariable [QGVAR(allowAnyDefault), true];

    private _dialogControls = [];
    if (!isNull _object) then {
        _dialogControls pushBack ["TOOLBOX:YESNO", ["Use existing object", "Re-use the module placement object as the feed screen."], true, true];
    };

    _dialogControls pushBack ["COMBO", ["Screen Type", "Projector model to spawn if needed."], [_screenTypes apply {_x select 0}, _screenTypes apply {_x select 1}, 0]];
    _dialogControls pushBack ["COMBO", ["UAV Source", "Drone providing the live feed."], [_uavValues, _uavNames, 0]];
    _dialogControls pushBack ["SLIDER", ["Initial FoV", "Default camera zoom for this screen."], [0.05, 1, _defaultFoV, 2]];
    _dialogControls pushBack ["COMBO", ["Vision Mode", "Initial PiP effect applied to the feed."], [[0, 1, 2], ["Normal", "Night Vision", "Thermal"], 0]];
    _dialogControls pushBack ["TOOLBOX:YESNO", ["Allow any player", "If disabled, only Zeus units may take feed control."], _defaultAllowAll, true];

    ["Roots Drone Feed", _dialogControls, {
        params ["_results", "_args"];
        _args params ["_posATL", "_object", "_screenTypes", "_uavData"];

        private _cursor = 0;
        private _useExisting = false;
        if (!isNull _object) then {
            _useExisting = _results select _cursor;
            _cursor = _cursor + 1;
        };

        private _screenClassResult = _results select _cursor;
        _cursor = _cursor + 1;
        private _screenClass = _screenClassResult;
        if (_screenClass isEqualType 0) then {
            _screenClass = (_screenTypes select _screenClass) select 0;
        };

        private _uavValue = _results select _cursor;
        _cursor = _cursor + 1;
        private _uav = objNull;
        if (_uavValue isEqualType 0) then {
            _uav = (_uavData select _uavValue) select 1;
        } else {
            _uav = objectFromNetId _uavValue;
        };

        if (isNull _uav) exitWith {
            ["Selected UAV is no longer available."] call zen_common_fnc_showMessage;
        };

        private _fov = _results select _cursor; _cursor = _cursor + 1;
        private _vision = _results select _cursor; _cursor = _cursor + 1;
        private _allowAll = _results select _cursor;

        private _screen = _object;
        if (isNull _object || {!_useExisting}) then {
            _screen = createVehicle [_screenClass, _posATL, [], 0, "CAN_COLLIDE"];
        };
        if (isNull _screen) exitWith {
            ["Unable to create or find a screen object."] call zen_common_fnc_showMessage;
        };

        _screen call zen_common_fnc_updateEditableObjects;

        [_screen, _uav, _fov, _vision, _allowAll, player] remoteExec ["root_dronefeed_fnc_registerScreen", 2];
        ["Roots Drone Feed screen initialized."] call zen_common_fnc_showMessage;
    }, {}, [_posATL, _object, _screenTypes, _uavData]] call zen_dialog_fnc_create;
}, _icon] call zen_custom_modules_fnc_register;

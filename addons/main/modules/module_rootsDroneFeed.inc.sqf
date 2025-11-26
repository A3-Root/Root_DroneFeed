#include "..\script_component.hpp"

if (!hasInterface) exitWith {};

private _screenTypes = [
    ["Land_TripodScreen_01_large_F", "Large Tripod Screen"],
    ["Land_PortableScreen_01_video_F", "Portable Screen"],
    ["Land_Billboard_06_F", "Billboard"]
];

private _icon = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa";

["Roots Drone Feed", "Create Feed Screen", {
    params ["_logicPos", "_object"];

    private _posATL = _logicPos;
    private _debugEnabled = missionNamespace getVariable [QGVAR(debugEnabled), false];
    private _logDebug = {
        params ["_message"];
        diag_log text format ["[Roots Drone Feed][Module] %1 | stack: %2", _message, diag_stacktrace];
    };
    if (_debugEnabled) then {
        ["Module invoked", format ["posATL=%1 object=%2", _posATL, _object]] call _logDebug;
    };

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

    // Zen COMBO defaults must match the value type; use the first entry explicitly
    private _defaultScreenClass = (_screenTypes select 0) select 0;
    private _defaultUavValue = _uavValues select 0;

    _dialogControls pushBack ["COMBO", ["Screen Type", "Projector model to spawn if needed."], [_screenTypes apply {_x select 0}, _screenTypes apply {_x select 1}, _defaultScreenClass]];
    _dialogControls pushBack ["COMBO", ["UAV Source", "Drone providing the live feed."], [_uavValues, _uavNames, _defaultUavValue]];
    _dialogControls pushBack ["SLIDER", ["Initial FoV", "Default camera zoom for this screen."], [0.05, 1, _defaultFoV, 2]];
    _dialogControls pushBack ["COMBO", ["Vision Mode", "Initial PiP effect applied to the feed."], [[0, 1, 2], ["Normal", "Night Vision", "Thermal"], 0]];
    _dialogControls pushBack ["TOOLBOX:YESNO", ["Allow any player", "If disabled, only Zeus units may take feed control."], _defaultAllowAll, true];

    if (_debugEnabled) then {
        ["Dialog controls prepared", format ["controls=%1", _dialogControls]] call _logDebug;
    };

    ["Roots Drone Feed", _dialogControls, {
        params ["_results", "_args"];
        _args params ["_posATL", "_object", "_screenTypes", "_uavData"];

        private _debugEnabled = missionNamespace getVariable [QGVAR(debugEnabled), false];
        private _logDebug = {
            params ["_message"];
            diag_log text format ["[Roots Drone Feed][Module] %1 | stack: %2", _message, diag_stacktrace];
        };
        if (_debugEnabled) then {
            ["Dialog submitted", format ["posATL=%1 object=%2 results=%3", _posATL, _object, _results]] call _logDebug;
        };

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
            if (_debugEnabled) then {["Selected UAV is null after selection", format ["uavValue=%1", _uavValue]] call _logDebug;};
        };

        private _fov = _results select _cursor; _cursor = _cursor + 1;
        private _vision = _results select _cursor; _cursor = _cursor + 1;
        private _allowAll = _results select _cursor;

        private _screen = _object;
        if (isNull _object || {!_useExisting}) then {
            _screen = createVehicle [_screenClass, _posATL, [], 0, "CAN_COLLIDE"];
            if (_debugEnabled) then {["Spawned screen object", format ["class=%1 posATL=%2 obj=%3", _screenClass, _posATL, _screen]] call _logDebug;};
        } else {
            if (_debugEnabled) then {["Reusing existing object", format ["object=%1", _screen]] call _logDebug;};
        };
        if (isNull _screen) exitWith {
            ["Unable to create or find a screen object."] call zen_common_fnc_showMessage;
            if (_debugEnabled) then {["Screen creation failed", ""] call _logDebug;};
        };

        _screen call zen_common_fnc_updateEditableObjects;

        [_screen, _uav, _fov, _vision, _allowAll, player] remoteExec ["root_dronefeed_fnc_registerScreen", 2];
        if (_debugEnabled) then {["RemoteExec registerScreen", format ["screen=%1 uav=%2 fov=%3 vision=%4 allowAll=%5", _screen, _uav, _fov, _vision, _allowAll]] call _logDebug;};
        ["Roots Drone Feed screen initialized."] call zen_common_fnc_showMessage;
    }, {}, [_posATL, _object, _screenTypes, _uavData]] call zen_dialog_fnc_create;
}, _icon] call zen_custom_modules_fnc_register;

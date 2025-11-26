#include "..\script_component.hpp"

params ["_context", ["_details", ""]];

if !(missionNamespace getVariable [QGVAR(debugEnabled), false]) exitWith {};

private _detailStr = _details;
if !(_detailStr isEqualType "") then {
    _detailStr = str _detailStr;
};

// Compact, filter stack trace to avoid huge blank sections
private _stackRaw = diag_stackTrace;
private _stackText = _stackRaw;
if (_stackRaw isEqualType []) then {
    private _filtered = _stackRaw select {
        _x isNotEqualTo "" && {str _x != "[]"}
    };
    _stackText = _filtered joinString " | ";
};

diag_log text format ["[Roots Drone Feed][%1] %2 | stack: %3", _context, _detailStr, _stackText];

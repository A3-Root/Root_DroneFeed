#include "..\script_component.hpp"

params ["_uav"];

["getAimPos start", format ["uav=%1", _uav]] call FUNC(debugLog);

if (isNull _uav) exitWith {[]};

private _cfg = configOf _uav;
private _camPosSel = getText (_cfg >> "uavCameraGunnerPos");
if (_camPosSel isEqualTo "") exitWith {[]};

private _camDirSel = getText (_cfg >> "uavCameraGunnerDir");
if (_camDirSel isEqualTo "") exitWith {[]};

private _camPosModel = _uav selectionPosition _camPosSel;
private _camDirModel = _uav selectionPosition _camDirSel;
private _start = _uav modelToWorldVisualWorld _camPosModel;
private _end = _uav modelToWorldVisualWorld (_camPosModel vectorAdd ((_camPosModel vectorFromTo _camDirModel) vectorMultiply 1e9));

private _hits = lineIntersectsSurfaces [_start, _end, _uav];
if (_hits isEqualTo []) exitWith {[]};

_hits select 0 select 0

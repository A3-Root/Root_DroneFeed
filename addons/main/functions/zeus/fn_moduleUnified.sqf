#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Unified Zeus module that automatically detects context
 *
 * Arguments:
 * 0: _logic <OBJECT> - Zeus logic module
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic] call Root_fnc_moduleUnified;
 *
 * Public: No
 */

params ["_logic"];

private _position = getPos _logic;
private _attachedObject = attachedTo _logic;
private _curator = player;

// Auto-detect context and call appropriate dialog
if (isNull _attachedObject) then {
    // Nothing attached - ground placement
    [_position, _curator] call FUNC(zeusDialogGround);
} else {
    // Something is attached - determine if it's a unit or object
    if (_attachedObject isKindOf "CAManBase") then {
        // Attached to a person (player or AI)
        [_attachedObject, _curator] call FUNC(zeusDialogPlayer);
    } else {
        // Attached to an object (screen/display)
        [_attachedObject, _curator] call FUNC(zeusDialogObject);
    };
};

deleteVehicle _logic;

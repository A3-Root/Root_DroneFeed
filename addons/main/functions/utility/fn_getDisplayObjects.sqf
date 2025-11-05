#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Get list of common display objects for Zeus selection
 *
 * Arguments: None
 *
 * Return Value:
 * <ARRAY> - Array of [classname, displayName] pairs
 *
 * Example:
 * private _displays = [] call Root_fnc_getDisplayObjects;
 *
 * Public: No
 */

private _displayObjects = [
    ["Land_BriefingRoomScreen_01_F", "Briefing Room Screen"],
    ["Land_PCSet_01_screen_F", "PC Screen"],
    ["Land_Laptop_03_black_F", "Laptop (Black)"],
    ["Land_Laptop_03_olive_F", "Laptop (Olive)"],
    ["Land_Laptop_03_sand_F", "Laptop (Sand)"],
    ["Billboard_01_blank_F", "Billboard (Large)"],
    ["Land_Billboard_F", "Billboard"],
    ["Land_TripodScreen_01_large_F", "Tripod Screen (Large)"],
    ["Land_TripodScreen_01_dual_v1_F", "Tripod Screen (Dual)"],
    ["Land_PortableScreen_01_large_F", "Portable Screen"],
    ["Land_FlatTV_01_F", "Flat TV"]
];

_displayObjects

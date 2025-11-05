#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Get the feed registry hashmap
 *
 * Arguments: None
 *
 * Return Value:
 * <HASHMAP> - Feed registry
 *
 * Example:
 * private _registry = [] call Root_fnc_getRegistry;
 *
 * Public: No
 */

private _registry = missionNamespace getVariable [GVAR_REGISTRY, createHashMap];

_registry

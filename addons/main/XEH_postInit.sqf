#include "script_component.hpp"

if (!hasInterface) exitWith {};

["XEH_postInit start", ""] call FUNC(debugLog);

call compile preprocessFileLineNumbers QPATHTOF(modules\module_rootsDroneFeed.inc.sqf);

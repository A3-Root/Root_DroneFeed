#include "script_component.hpp"
/*
 * Author: Root
 * Description: CBA PreInit Event Handler
 *              Executes before mission init to prepare functions and settings
 *
 * Responsibilities:
 * - Precompile all function files via XEH_PREP.hpp
 * - Initialize CBA settings for mission configuration
 * - Set up mod components before mission objects spawn
 *
 * Execution Order: PreInit -> PostInit -> Mission Objects Created
 *
 * Public: No
 */

ADDON = false;

#include "XEH_PREP.hpp"

call FUNC(initSettings);

ADDON = true;

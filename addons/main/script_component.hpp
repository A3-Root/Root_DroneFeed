/*
 * Author: Root
 * Description: Component script header
 *              Defines component name and includes mod configuration
 * 
 * Public: No
 */

#define COMPONENT main
#define COMPONENT_BEAUTIFIED Main
#include "\z\root_dronefeed\addons\main\script_mod.hpp"

// Enable debug mode (comment out for production)
#define DEBUG_ENABLED_ROOT_DRONEFEED
#ifdef DEBUG_ENABLED_ROOT_DRONEFEED
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_ROOT_DRONEFEED
    #define DEBUG_SETTINGS DEBUG_SETTINGS_ROOT_DRONEFEED
#endif

#include "\z\root_dronefeed\addons\main\script_macros.hpp"

#include "script_mod.hpp"
#include "CfgFunctions.hpp"
#include "CfgVehicles.hpp"
#include "CfgFactionClasses.hpp"

class CfgPatches {
    class ROOT_DroneFeed {
        name = "Root's Drone Feed";
        units[] = {
            "ROOT_DroneFeed_Module"
        };
        requiredAddons[] = {
            "A3_Modules_F_Curator",
            "cba_main",
            "cba_settings",
            "zen_custom_modules"
        };
        weapons[] = {};
        author = "Root";
        url = "https://github.com/A3-Root/Root_DroneFeed";
        requiredVersion = REQUIRED_VERSION;
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"

#include "script_component.hpp"

class CfgPatches {
    class root_dronefeed_main {
        name = MOD_NAME;
        author = "Roots";
        url = "https://github.com/roots";
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "zen_common",
            "zen_context_actions",
            "zen_custom_modules"
        };
        units[] = {};
        weapons[] = {};
    };
};

#include "CfgEventHandlers.hpp"

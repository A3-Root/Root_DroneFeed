class Extended_PreInit_EventHandlers {
    class root_dronefeed_pre_init {
        init = "call compile preprocessFileLineNumbers '\z\root_dronefeed\addons\main\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers {
    class root_dronefeed_post_init {
        init = "call compile preprocessFileLineNumbers '\z\root_dronefeed\addons\main\XEH_postInit.sqf'";
    };
};

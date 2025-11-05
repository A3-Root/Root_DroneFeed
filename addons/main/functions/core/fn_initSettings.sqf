#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Initialize CBA settings for ROOT_DroneFeed
 *
 * Arguments: None
 *
 * Return Value: None
 *
 * Example:
 * [] call Root_fnc_initSettings;
 *
 * Public: No
 */

[
    SETTING_MULTI_CONTROL,
    "CHECKBOX",
    [localize "STR_ROOT_DRONEFEED_SETTING_MULTI_CONTROL", localize "STR_ROOT_DRONEFEED_SETTING_MULTI_CONTROL_DESC"],
    localize "STR_ROOT_DRONEFEED_SETTINGS_CATEGORY",
    false,
    1,
    {}
] call CBA_fnc_addSetting;

[
    SETTING_DEFAULT_RADIUS,
    "SLIDER",
    [localize "STR_ROOT_DRONEFEED_SETTING_DEFAULT_RADIUS", localize "STR_ROOT_DRONEFEED_SETTING_DEFAULT_RADIUS_DESC"],
    localize "STR_ROOT_DRONEFEED_SETTINGS_CATEGORY",
    [0, 1000, DEFAULT_ACTIVATION_RADIUS, 0],
    1,
    {}
] call CBA_fnc_addSetting;

[
    SETTING_ACE_ENABLED,
    "CHECKBOX",
    [localize "STR_ROOT_DRONEFEED_SETTING_ACE_ENABLED", localize "STR_ROOT_DRONEFEED_SETTING_ACE_ENABLED_DESC"],
    localize "STR_ROOT_DRONEFEED_SETTINGS_CATEGORY",
    true,
    1,
    {}
] call CBA_fnc_addSetting;

[
    SETTING_ADMIN_NOTIFY,
    "LIST",
    [localize "STR_ROOT_DRONEFEED_SETTING_ADMIN_NOTIFY", localize "STR_ROOT_DRONEFEED_SETTING_ADMIN_NOTIFY_DESC"],
    localize "STR_ROOT_DRONEFEED_SETTINGS_CATEGORY",
    [
        ["hint", "systemChat", "none"],
        ["Hint", "System Chat", "None"],
        0
    ],
    1,
    {}
] call CBA_fnc_addSetting;

[
    SETTING_DEFAULT_ALTITUDE,
    "SLIDER",
    [localize "STR_ROOT_DRONEFEED_SETTING_DEFAULT_ALTITUDE", localize "STR_ROOT_DRONEFEED_SETTING_DEFAULT_ALTITUDE_DESC"],
    localize "STR_ROOT_DRONEFEED_SETTINGS_CATEGORY",
    [100, 5000, DEFAULT_CAMERA_ALTITUDE, 0],
    1,
    {}
] call CBA_fnc_addSetting;

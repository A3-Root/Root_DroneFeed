/*
 * Author: Root
 * Description: Macro definitions for ROOT_DroneFeed addon
 *              Provides constants, utility macros, and logging
 *
 * Notes:
 * - Common CBA macros (QUOTE, QGVAR, GVAR, DOUBLES, TRIPLES, FUNC) are imported via script_mod.hpp
 * - Debug macros are conditionally compiled based on DEBUG_MODE_FULL
 *
 * Public: No
 */

// ============================================================================
// Constants - Feed Modes
// ============================================================================
#ifndef FEED_MODE_DRONE
    #define FEED_MODE_DRONE "DRONE"
#endif
#ifndef FEED_MODE_SATELLITE
    #define FEED_MODE_SATELLITE "SATELLITE"
#endif

// ============================================================================
// Constants - Default Values
// ============================================================================
#ifndef DEFAULT_CAMERA_ALTITUDE
    #define DEFAULT_CAMERA_ALTITUDE 1000
#endif
#ifndef DEFAULT_DRONE_ALTITUDE
    #define DEFAULT_DRONE_ALTITUDE 2000
#endif
#ifndef DEFAULT_ACTIVATION_RADIUS
    #define DEFAULT_ACTIVATION_RADIUS 100
#endif
#ifndef DEFAULT_CAMERA_FOV
    #define DEFAULT_CAMERA_FOV 0.7
#endif

// ============================================================================
// Constants - Camera Zoom Levels
// ============================================================================
#ifndef ZOOM_LEVEL_1
    #define ZOOM_LEVEL_1 0.7
#endif
#ifndef ZOOM_LEVEL_2
    #define ZOOM_LEVEL_2 0.4
#endif
#ifndef ZOOM_LEVEL_3
    #define ZOOM_LEVEL_3 0.1
#endif
#ifndef ZOOM_LEVEL_4
    #define ZOOM_LEVEL_4 0.07
#endif
#ifndef ZOOM_LEVEL_5
    #define ZOOM_LEVEL_5 0.04
#endif
#ifndef ZOOM_LEVEL_6
    #define ZOOM_LEVEL_6 0.01
#endif

// ============================================================================
// Constants - Vision Modes (setPiPEffect values)
// ============================================================================
#ifndef VISION_MODE_NORMAL
    #define VISION_MODE_NORMAL 0
#endif
#ifndef VISION_MODE_NV
    #define VISION_MODE_NV 1
#endif
#ifndef VISION_MODE_THERMAL
    #define VISION_MODE_THERMAL 2
#endif

// ============================================================================
// Global Variable Keys
// ============================================================================
#ifndef GVAR_REGISTRY
    #define GVAR_REGISTRY "ROOT_DRONEFEED_REGISTRY"
#endif
#ifndef GVAR_FEED_COUNTER
    #define GVAR_FEED_COUNTER "ROOT_DRONEFEED_FEED_COUNTER"
#endif
#ifndef GVAR_CLIENT_FEEDS
    #define GVAR_CLIENT_FEEDS "ROOT_DRONEFEED_CLIENT_FEEDS"
#endif

// ============================================================================
// Setting Keys
// ============================================================================
#ifndef SETTING_MULTI_CONTROL
    #define SETTING_MULTI_CONTROL "ROOT_DRONEFEED_MULTI_CONTROL"
#endif
#ifndef SETTING_DEFAULT_RADIUS
    #define SETTING_DEFAULT_RADIUS "ROOT_DRONEFEED_DEFAULT_RADIUS"
#endif
#ifndef SETTING_ACE_ENABLED
    #define SETTING_ACE_ENABLED "ROOT_DRONEFEED_ACE_ENABLED"
#endif
#ifndef SETTING_ADMIN_NOTIFY
    #define SETTING_ADMIN_NOTIFY "ROOT_DRONEFEED_ADMIN_NOTIFY"
#endif
#ifndef SETTING_DEFAULT_ALTITUDE
    #define SETTING_DEFAULT_ALTITUDE "ROOT_DRONEFEED_DEFAULT_ALTITUDE"
#endif

// ============================================================================
// CBA Event Names
// ============================================================================
#ifndef EVENT_FEED_CREATED
    #define EVENT_FEED_CREATED "root_dronefeed_feedCreated"
#endif
#ifndef EVENT_FEED_DELETED
    #define EVENT_FEED_DELETED "root_dronefeed_feedDeleted"
#endif
#ifndef EVENT_FEED_MODIFIED
    #define EVENT_FEED_MODIFIED "root_dronefeed_feedModified"
#endif
#ifndef EVENT_CONTROL_REQUESTED
    #define EVENT_CONTROL_REQUESTED "root_dronefeed_controlRequested"
#endif
#ifndef EVENT_CONTROL_GRANTED
    #define EVENT_CONTROL_GRANTED "root_dronefeed_controlGranted"
#endif
#ifndef EVENT_CONTROL_RELEASED
    #define EVENT_CONTROL_RELEASED "root_dronefeed_controlReleased"
#endif
#ifndef EVENT_CAMERA_UPDATE
    #define EVENT_CAMERA_UPDATE "root_dronefeed_cameraUpdate"
#endif
#ifndef EVENT_CAMERA_ZOOM
    #define EVENT_CAMERA_ZOOM "root_dronefeed_cameraZoom"
#endif
#ifndef EVENT_CAMERA_VISION
    #define EVENT_CAMERA_VISION "root_dronefeed_cameraVision"
#endif

// ============================================================================
// Debug Logging Macros (Conditionally Compiled)
// ============================================================================
#ifdef DEBUG_MODE_FULL
    #ifndef LOG_DEBUG
        #define LOG_DEBUG(msg) diag_log text format ["[ROOT_DRONEFEED DEBUG] %1", msg]
    #endif
    #ifndef LOG_DEBUG_1
        #define LOG_DEBUG_1(msg,arg1) diag_log text format ["[ROOT_DRONEFEED DEBUG] " + msg, arg1]
    #endif
    #ifndef LOG_DEBUG_2
        #define LOG_DEBUG_2(msg,arg1,arg2) diag_log text format ["[ROOT_DRONEFEED DEBUG] " + msg, arg1, arg2]
    #endif
    #ifndef LOG_DEBUG_3
        #define LOG_DEBUG_3(msg,arg1,arg2,arg3) diag_log text format ["[ROOT_DRONEFEED DEBUG] " + msg, arg1, arg2, arg3]
    #endif
    #ifndef LOG_DEBUG_4
        #define LOG_DEBUG_4(msg,arg1,arg2,arg3,arg4) diag_log text format ["[ROOT_DRONEFEED DEBUG] " + msg, arg1, arg2, arg3, arg4]
    #endif
#else
    // No-op when debug disabled
    #ifndef LOG_DEBUG
        #define LOG_DEBUG(msg)
    #endif
    #ifndef LOG_DEBUG_1
        #define LOG_DEBUG_1(msg,arg1)
    #endif
    #ifndef LOG_DEBUG_2
        #define LOG_DEBUG_2(msg,arg1,arg2)
    #endif
    #ifndef LOG_DEBUG_3
        #define LOG_DEBUG_3(msg,arg1,arg2,arg3)
    #endif
    #ifndef LOG_DEBUG_4
        #define LOG_DEBUG_4(msg,arg1,arg2,arg3,arg4)
    #endif
#endif

// Error and info logging (always enabled)
#ifndef LOG_ERROR
    #define LOG_ERROR(msg) diag_log text format ["[ROOT_DRONEFEED ERROR] %1", msg]
#endif
#ifndef LOG_ERROR_1
    #define LOG_ERROR_1(msg,arg1) diag_log text format ["[ROOT_DRONEFEED ERROR] " + msg, arg1]
#endif
#ifndef LOG_ERROR_2
    #define LOG_ERROR_2(msg,arg1,arg2) diag_log text format ["[ROOT_DRONEFEED ERROR] " + msg, arg1, arg2]
#endif
#ifndef LOG_ERROR_3
    #define LOG_ERROR_3(msg,arg1,arg2,arg3) diag_log text format ["[ROOT_DRONEFEED ERROR] " + msg, arg1, arg2, arg3]
#endif

#ifndef LOG_INFO
    #define LOG_INFO(msg) diag_log text format ["[ROOT_DRONEFEED INFO] %1", msg]
#endif
#ifndef LOG_INFO_1
    #define LOG_INFO_1(msg,arg1) diag_log text format ["[ROOT_DRONEFEED INFO] " + msg, arg1]
#endif
#ifndef LOG_INFO_2
    #define LOG_INFO_2(msg,arg1,arg2) diag_log text format ["[ROOT_DRONEFEED INFO] " + msg, arg1, arg2]
#endif
#ifndef LOG_INFO_3
    #define LOG_INFO_3(msg,arg1,arg2,arg3) diag_log text format ["[ROOT_DRONEFEED INFO] " + msg, arg1, arg2, arg3]
#endif

// ============================================================================
// Validation Macros
// ============================================================================
#ifndef VALIDATE_OBJECT
    #define VALIDATE_OBJECT(obj) (!isNull obj)
#endif
#ifndef VALIDATE_FEED_MODE
    #define VALIDATE_FEED_MODE(mode) (mode in [FEED_MODE_DRONE, FEED_MODE_SATELLITE])
#endif

// ============================================================================
// Color Codes for UI Output
// ============================================================================
#ifndef COLOR_SUCCESS
    #define COLOR_SUCCESS "#8ce10b"     // Green
#endif
#ifndef COLOR_ERROR
    #define COLOR_ERROR "#fa4c58"       // Red
#endif
#ifndef COLOR_WARNING
    #define COLOR_WARNING "#FFD966"     // Yellow
#endif
#ifndef COLOR_INFO
    #define COLOR_INFO "#008DF8"        // Blue
#endif
#ifndef COLOR_NEUTRAL
    #define COLOR_NEUTRAL "#BCBCBC"     // Gray
#endif

// ============================================================================
// Registry Access Macros
// ============================================================================
#ifndef GET_REGISTRY
    #define GET_REGISTRY (missionNamespace getVariable [GVAR_REGISTRY, createHashMap])
#endif
#ifndef SET_REGISTRY
    #define SET_REGISTRY(value) missionNamespace setVariable [GVAR_REGISTRY, value, true]
#endif
#ifndef GET_CLIENT_FEEDS
    #define GET_CLIENT_FEEDS (missionNamespace getVariable [GVAR_CLIENT_FEEDS, createHashMap])
#endif
#ifndef SET_CLIENT_FEEDS
    #define SET_CLIENT_FEEDS(value) missionNamespace setVariable [GVAR_CLIENT_FEEDS, value, false]
#endif

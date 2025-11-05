/*
 * Author: Root
 * Description: Main mod script header
 *              Defines version, prefixes, and imports CBA macros
 * 
 * Public: No
 */

#include "script_version.hpp"

#define MAINPREFIX z
#define PREFIX root_dronefeed

#define VERSION     MAJOR.MINOR
#define VERSION_STR MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR  MAJOR,MINOR,PATCHLVL,BUILD

// Minimum required Arma 3 version
#define REQUIRED_VERSION 2.18

// Import CBA macros (QUOTE, QGVAR, GVAR, DOUBLES, TRIPLES, FUNC, etc.)
#include "\x\cba\addons\main\script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

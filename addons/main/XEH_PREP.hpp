// Core functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\core\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(initSettings);
PREP(createFeed);
PREP(deleteFeed);
PREP(modifyFeed);
PREP(getFeedData);
PREP(generateFeedId);
PREP(getRegistry);

// Camera functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\camera\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(createCamera);
PREP(destroyCamera);
PREP(updateCameraPosition);
PREP(setZoom);
PREP(setVision);
PREP(setupCameraHandlers);

// Control functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\control\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(requestControl);
PREP(grantControl);
PREP(releaseControl);
PREP(checkAccess);
PREP(addControlActions);
PREP(openMapControl);

// Drone functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\drone\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(setupDroneFeed);
PREP(getDroneList);
PREP(spawnDrone);
PREP(trackDroneTurret);
PREP(linkDroneToFeed);

// Satellite functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\satellite\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(setupSatelliteFeed);
PREP(updateSatellitePosition);
PREP(handleMapClick);

// Monitoring functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\monitoring\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(monitorFeeds);
PREP(handleDroneDeath);
PREP(handleScreenDeletion);
PREP(notifyAdmin);

// Utility functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\utility\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(getDisplayObjects);
PREP(validateConfig);
PREP(getAuthorizedPlayers);
PREP(formatNotification);

// Zeus functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\zeus\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleUnified);
PREP(zeusDialogGround);
PREP(zeusDialogPlayer);
PREP(zeusDialogAI);
PREP(zeusDialogObject);
PREP(zeusDialogModify);

// API functions
#undef PREP
#define PREP(fncName) [QPATHTOF(functions\api\DOUBLES(fn,fncName).sqf),QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(apiCreateFeed);
PREP(apiDeleteFeed);
PREP(apiModifyFeed);
PREP(apiListFeeds);

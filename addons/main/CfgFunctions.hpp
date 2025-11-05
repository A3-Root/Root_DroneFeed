class CfgFunctions {
    class Root {
        tag = "Root";
        
        class Core {
            file = "\z\root_dronefeed\addons\main\functions\core";
            class initSettings {};
            class createFeed {};
            class deleteFeed {};
            class modifyFeed {};
            class getFeedData {};
            class generateFeedId {};
            class getRegistry {};
        };
        
        class Camera {
            file = "\z\root_dronefeed\addons\main\functions\camera";
            class createCamera {};
            class destroyCamera {};
            class updateCameraPosition {};
            class setZoom {};
            class setVision {};
            class setupCameraHandlers {};
        };
        
        class Control {
            file = "\z\root_dronefeed\addons\main\functions\control";
            class requestControl {};
            class grantControl {};
            class releaseControl {};
            class checkAccess {};
            class addControlActions {};
            class openMapControl {};
        };
        
        class Drone {
            file = "\z\root_dronefeed\addons\main\functions\drone";
            class setupDroneFeed {};
            class getDroneList {};
            class spawnDrone {};
            class trackDroneTurret {};
            class linkDroneToFeed {};
        };
        
        class Satellite {
            file = "\z\root_dronefeed\addons\main\functions\satellite";
            class setupSatelliteFeed {};
            class updateSatellitePosition {};
            class handleMapClick {};
        };
        
        class Monitoring {
            file = "\z\root_dronefeed\addons\main\functions\monitoring";
            class monitorFeeds {};
            class handleDroneDeath {};
            class handleScreenDeletion {};
            class notifyAdmin {};
        };
        
        class Utility {
            file = "\z\root_dronefeed\addons\main\functions\utility";
            class getDisplayObjects {};
            class validateConfig {};
            class getAuthorizedPlayers {};
            class formatNotification {};
        };
        
        class Zeus {
            file = "\z\root_dronefeed\addons\main\functions\zeus";
            class moduleUnified {};
            class zeusDialogGround {};
            class zeusDialogPlayer {};
            class zeusDialogAI {};
            class zeusDialogObject {};
            class zeusDialogModify {};
        };
        
        class API {
            file = "\z\root_dronefeed\addons\main\functions\api";
            class apiCreateFeed {};
            class apiDeleteFeed {};
            class apiModifyFeed {};
            class apiListFeeds {};
        };
    };
};

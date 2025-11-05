livefeed_display_1 = "Land_BriefingRoomScreen_01_F" createVehicle [550.533, 4516.7, 0];   
camsource_1 = createVehicle ["USAF_RQ4A", [0,100,1000], [], 0, "FLY"];    
livefeed_display_1 setObjectTextureGlobal [0, "#(argb,512,512,1)r2t(uavrtt,1)"];   
createVehicleCrew camsource_1;    
camsource_1 lockCameraTo [livefeed_display_1, [0]];    
camsource_1 flyInHeight 1000;    
_wp = group camsource_1 addWaypoint [position livefeed_display_1, 0];    
_wp setWaypointType "LOITER";    
_wp setWaypointLoiterType "CIRCLE_L";    
_wp setWaypointLoiterRadius 2000;    
publicVariable "camsource_1";   
publicVariable "livefeed_display_1";   
{  
    camfeed_1 = "camera" camCreate [0,0,0];    
    camfeed_1 cameraEffect ["Internal", "Back", "uavrtt"];    
    camfeed_1 attachTo [camsource_1, [0,0,0], "PiP0_pos"];
    camfeed_1 camSetTarget [550.533, 4516.7, 0]; 
    camfeed_1 camSetFov 0.1;
    camfeed_1 camCommit 0;    
    addMissionEventHandler ["Draw3D", {   
        _dir = (camsource_1 selectionPosition "PiP0_pos") vectorFromTo (camsource_1 selectionPosition "PiP0_dir");    
        camfeed_1 setVectorDirAndUp [ _dir, _dir vectorCrossProduct [-(_dir select 1), _dir select 0, 0]];    
    }];
    ["featureCamera", {camfeed_1 cameraEffect ["Internal", "Back", "uavrtt"]}] call CBA_fnc_addPlayerEventHandler;     
} remoteExec ["call", [0, -2] select isDedicated, camsource_1];
#include "\z\root_dronefeed\addons\main\script_component.hpp"
params [["_attachedObject", objNull], ["_curator", objNull]];

private _displayObjects = call FUNC(getDisplayObjects);
private _displayValues = _displayObjects apply {_x select 0};
private _displayNames = _displayObjects apply {_x select 1};

[
    localize "STR_ROOT_DRONEFEED_ZEUS_PLAYER_TITLE",
    [
        ["COMBO", localize "STR_ROOT_DRONEFEED_DISPLAY_OBJECT", [_displayValues, _displayNames, 0]],
        ["EDIT", localize "STR_ROOT_DRONEFEED_CUSTOM_OBJECT", [""]],
        ["SLIDER", localize "STR_ROOT_DRONEFEED_TEXTURE_ID", [0, 5, 0, 0]],
        ["TOOLBOX", localize "STR_ROOT_DRONEFEED_OWNERSHIP", [0, 1, 2, ["Player Only", "Entire Group"]]],
        ["COMBO", localize "STR_ROOT_DRONEFEED_FEED_MODE", [["DRONE", "SATELLITE"], ["Drone Feed", "Satellite Feed"], 0]],
        ["SLIDER", localize "STR_ROOT_DRONEFEED_ALTITUDE", [100, 5000, 1000, 0]],
        ["SLIDER", localize "STR_ROOT_DRONEFEED_RADIUS", [0, 1000, 100, 0]]
    ],
    {
        params ["_results", "_args"];
        _results params ["_displayClass", "_customObject", "_textureId", "_ownership", "_feedMode", "_altitude", "_radius"];
        _args params ["_attachedObject", "_curator"];

        private _screenClass = [_customObject, _displayClass] select (_customObject isEqualTo "");
        private _screenObject = createVehicle [_screenClass, getPos _attachedObject, [], 0, "CAN_COLLIDE"];

        private _authorizedUsers = [[group _attachedObject], [_attachedObject]] select (_ownership isEqualTo 0);
        
        if (_feedMode isEqualTo "SATELLITE") then {
            [_screenObject, _textureId, _authorizedUsers, "SATELLITE", _altitude, _radius, _curator] remoteExec [QFUNC(createFeed), 2];
            [localize "STR_ROOT_DRONEFEED_FEED_CREATED"] call zen_common_fnc_showMessage;
        } else {
            private _drones = call FUNC(getDroneList);
            if (count _drones > 0) then {
                private _droneValues = _drones apply {_x select 0};
                private _droneNames = _drones apply {_x select 1};
                [
                    localize "STR_ROOT_DRONEFEED_SELECT_DRONE",
                    [
                        ["COMBO", localize "STR_ROOT_DRONEFEED_DRONE", [_droneValues, _droneNames, 0]],
                        ["TOOLBOX", localize "STR_ROOT_DRONEFEED_OR_SPAWN_NEW", [0, 1, 2, ["Select Existing", "Spawn New"]]],
                        ["EDIT", localize "STR_ROOT_DRONEFEED_DRONE_CLASS", ["B_UAV_02_dynamicLoadout_F"]],
                        ["SLIDER", localize "STR_ROOT_DRONEFEED_DRONE_ALTITUDE", [500, 3000, 2000, 0]]
                    ],
                    {
                        params ["_droneResults", "_droneArgs"];
                        _droneResults params ["_selectedDrone", "_spawnNew", "_droneClass", "_droneAlt"];
                        _droneArgs params ["_screenObject", "_textureId", "_authorizedUsers", "_radius", "_curator"];
                        
                        private _drone = if (_spawnNew isEqualTo 1) then {
                            [_droneClass, getPos _screenObject, _droneAlt] call FUNC(spawnDrone);
                        } else {
                            _selectedDrone
                        };
                        
                        if (!isNull _drone) then {
                            [_screenObject, _textureId, _authorizedUsers, "DRONE", _drone, _radius, _curator] remoteExec [QFUNC(createFeed), 2];
                            [localize "STR_ROOT_DRONEFEED_FEED_CREATED"] call zen_common_fnc_showMessage;
                        };
                    },
                    {},
                    [_screenObject, _textureId, _authorizedUsers, _radius, _curator]
                ] call zen_dialog_fnc_create;
            };
        };
    },
    {},
    [_attachedObject, _curator]
] call zen_dialog_fnc_create;

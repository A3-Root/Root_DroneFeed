#include "..\script_component.hpp"

params ["_message"];

if (!hasInterface) exitWith {};

["notifyPlayer start", format ["message=%1", _message]] call FUNC(debugLog);

systemChat _message;

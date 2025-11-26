#include "..\script_component.hpp"

params ["_message"];

if (!hasInterface) exitWith {};

systemChat _message;

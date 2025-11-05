#include "\z\root_dronefeed\addons\main\script_component.hpp"
/*
 * Author: Root
 * Description: Public API to list all active feeds
 *
 * Arguments: None
 *
 * Return Value:
 * <ARRAY> - Array of feed data hashmaps
 *
 * Example:
 * private _feeds = [] call Root_fnc_apiListFeeds;
 * {
 *     systemChat format ["Feed: %1, Mode: %2", _x get "feedId", _x get "feedMode"];
 * } forEach _feeds;
 *
 * Public: Yes
 */

private _registry = call FUNC(getRegistry);
private _feeds = [];

{
    _feeds pushBack _y;
} forEach _registry;

_feeds

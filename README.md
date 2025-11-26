# Roots Drone Feed

Client-side Zeus module that spawns projector screens showing the turret feed of a selected UAV. Only the Zeus (mission maker) needs the mod; other players receive the lightweight runtime scripts via `remoteExec`.

## Features

- Spawn or bind to an existing object to use as the feed screen.
- Supports multiple projector types (billboard, tripod screen, portable).
- Zeus-configurable FoV defaults and access permissions via CBA settings.
- Any player near the screen can take feed control through the vanilla UAV terminal workflow.
- Viewers can change FoV or vision mode (normal, NV, TI) locally on the screen.
- Aggressive `featureCamera`/`cameraView` handlers keep the PiP stable when players change inventory, Zeus, etc.

## Requirements

- Arma 3 (latest stable branch)
- CBA_A3
- ZEN (Zeus Enhanced)

## Build

```sh
hemtt build
```

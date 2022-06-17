# Motion Based Mini Games

This repository contains a number of mini games, inspired by the Mario Party game series. Groups of up to four players must work together to complete the objectives. All games can be played using motion controls or standard button controls.

## Games

### Fishing Game

Players need to time their movement to raise the net and catch fish.

### Balance Game

Player need to work together to move the scale and thus avoid obstacles.

## Running Games with the JoyCons

Before opening the Godot editor or starting an exported game install the library `libhidapi-hidraw0` and run `sudo chmod 0666 /dev/hidraw*`. Changing the permissions needs to be done after each restart of the computer and after each new connect of a controller. Then start the editor, specifying the path to your JoyCon library. E.g. when starting the editor from the `MotionGames` folder use `LD_LIBRARY_PATH=JoyCons/ path/to/godot -e`.

## Making a New Game

- Main Scene of the game should be the `NetworkGame` node, which is provided by the addons. Set the max player count to `4` and set the `Player Scene` and `Players Container`.
- The scene below should contain the actual game, the script should inherit from `MiniGame`.
- Add the `Explanation` node from the `ui` folder to the scene. You can set the title of the game and a short explanation. This should be at the bottom of your hierarchy, so the explanation is displayed on top of the game and the blur effect is applied correctly.
- Add the `UI` node from the `ui` folder. It provides a timer that runs that game. Connect the `timeout` of the `UI` component to the `_on_timeout()` method in your main game scene.
- The `MiniGame` then handles starting and stopping the game. It provides the signals `start` and `stop` which your components can subscribe to. You can use this, for example, to start and stop spawning mechanisms. You can also check whether a game is currently running, using the `running` parameter. Components should reset any relevant progress variables on receiving the `stop` signal, in order to allow multiple runs of the game.
- To update the score use the `update_score(delta)` function on the `UI` node. This only needs to be done on the network master. The delta should be the points gained or lost, rather than the point total.
- To add support for the JoyCons, you can inherit the player (if it is a `KinematicBody2D`) from the `MiniGamePlayer`. Then just call the `setup_joycons(player_count)` function from `_ready()` if it is the network master. Alternatively, add the `JoyCon2D` scene to the player in the `_ready()` function if it is the network master and handle assigning the device number yourself.
- You can extend the attached `JoyCon2D.gd` script to check for further movement types.
- To be able to test the game, add a name for the game and its main scene to the relevant places in the `Main.gd`.
- Specify ports for the game in `GameSettings.gd`.

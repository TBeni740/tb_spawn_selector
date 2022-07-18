# tb_spawn_selector
**__Simple and clean FiveM spawn selector__**

If you want to add the feature of last location you will need to extract player's last location using your framework and pass it as a parameter in the **tb_spawn_selector:turnOnSpawnSelector** event.

**[Preview](https://streamable.com/o17n4s)**

**Notice** that at the end of the video, the ped just fall on the floor when he spawned, I managed to fix this problem.

If you want to disable the auto appearance of the spawn selector UI when you loading into the server, just disable the playerSpawned event in the client.lua. After that trigger the tb_spawn_selector:turnOnSpawnSelector when ever you want the spawn selector UI to be showed on the screen.

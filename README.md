# Half-Life: Alyx - Vending Shop Prefab
This is a vending shop prefab for map creators to use in custom Half-Life: Alyx maps.
<br />
<br />
It has 6 slots for items that players can purchase using resin. The items can either be randomized or the map creator can choose what goes in each slot along with their cost. The items are ammo, grenades and syringes. The map creator can also place custom items, like a keycard.

## Prefab Variables
These variables can be changed per prefab instance to customize how the shop functions.

Prefab Variable | Default Value | Description
--- | --- | ---
Start Active | On | Start the vending shop activated<br />Items will only be spawned while active
Starting Currency Amount | 0 | How much currency the vending shop starts with
Extra Lights | Off | Turn on extra lighting, useful for dark places
Tutorial | On | Enable tutorial that shows players where to put currency<br />Only shows once globabally per new game
Disable Emit Trigger | Off | Disable the trigger that allows the player to take resin out of their backpack<br />This can be used if you want to use your own trigger that fits the environment shape better
Slot 1 Cost | -1 | Cost of slot 1, will be assigned automatically when set to -1
Slot 2 Cost | -1 | Cost of slot 2, will be assigned automatically when set to -1
Slot 3 Cost | -1 | Cost of slot 3, will be assigned automatically when set to -1
Slot 4 Cost | -1 | Cost of slot 4, will be assigned automatically when set to -1
Slot 5 Cost | -1 | Cost of slot 5, will be assigned automatically when set to -1
Slot 6 Cost | -1 | Cost of slot 6, will be assigned automatically when set to -1
Slot 1 Item | Random | Type of item inside slot 1
Slot 2 Item | Random | Type of item inside slot 2
Slot 3 Item | Random | Type of item inside slot 3
Slot 4 Item | Random | Type of item inside slot 4
Slot 5 Item | Random | Type of item inside slot 5
Slot 6 Item | Random | Type of item inside slot 6

## Prefab Variables - Advanced
These can break the whole vending shop if formatted incorrectly, so only change them if you need to.<br />

Prefab Variable | Default Value | Description
--- | --- | ---
Random Item Chances | item_hlvr_clip_energygun=80, <br />item_hlvr_clip_energygun_multiple=20, <br />item_hlvr_clip_shotgun_multiple=100, <br />item_hlvr_clip_rapidfire=100, item_hlvr_grenade_frag=50, <br />item_hlvr_grenade_xen=50, <br />item_healthvial=100 | Comma separated string to assign chance (0 to 100) for randomized slots
Item Costs<br />(when -1) | item_hlvr_clip_energygun=3, <br />item_hlvr_clip_energygun_multiple=10, <br />item_hlvr_clip_shotgun_multiple=6, <br />item_hlvr_clip_rapidfire=8, item_hlvr_grenade_frag=5, <br />item_hlvr_grenade_xen=5, <br />item_healthvial=5 | Comma separated string to assign cost for item types<br />These only get applied when the slot cost is set to -1

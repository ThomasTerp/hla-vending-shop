# Half-Life: Alyx - Vending Shop Prefab
A vending shop prefab for map creators to use in custom Half-Life: Alyx maps.
<img src="https://user-images.githubusercontent.com/3063873/93004076-0ba27980-f544-11ea-9760-52c59b0b8bca.png" />
<br />
It has 6 slots for items that players can purchase using resin. The items can either be randomized or map creators can choose what goes in each slot along with their cost. The items are ammo, grenades and syringes. Map creators can also place custom items, like a keycard.
## Installing
Follow these steps to install it for use with your addon:
1. Download the <a href="https://github.com/ThomasTerp/hla-vending-shop/releases">latest release</a>
2. Extract the folders inside of `\game\hla_addons\vending_shop\` into your<br />`C:\Program Files (x86)\Steam\steamapps\common\Half-Life Alyx\game\hlvr_addons\<YOUR ADDON NAME>\` folder
3. Extract the folders inside of `\content\hla_addon\vending_shop\` into your<br />`C:\Program Files (x86)\Steam\steamapps\common\Half-Life Alyx\content\hlvr_addons\<YOUR ADDON NAME>\` folder

**Note: If you installed the demo map, remember to remove that map before publishing your map to the workshop, remove all files named `vending_shop_demo` from these locations:**
* **`\content\hlvr_addons\<YOUR ADDON NAME>\maps\`**
* **`\game\hlvr_addons\<YOUR ADDON NAME>\maps\`**
* **`\game\hlvr_addons\<YOUR ADDON NAME>\maps\graphs\`**
## How to use
Follow these steps to add a vending shop to your map:
1. Open the `Prefabs` tab at top of the Hammer window
2. Select `Import Prefab`
3. Find the folder containing the vending shop prefab in `\content\hlvr_addons\<YOUR ADDON NAME>\maps\prefabs\vending_shop\` and open `vending_shop.vmap`
4. The prefab should now be added to the map and is ready to use
5. Optionally you can change the properties of the prefab to your liking, see [Prefab Variables](#prefab-variables) below for more detailed descriptions of each variable
## Features
## Prefab Variables
These variables can be changed per prefab instance to customize how the vending shop functions.
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
These variables can break the whole vending shop if formatted incorrectly, so only change them if you know what you are doing.
Prefab Variable | Default Value | Description
--- | --- | ---
Random Item Chances | item_hlvr_clip_energygun=80, <br />item_hlvr_clip_energygun_multiple=20, <br />item_hlvr_clip_shotgun_multiple=100, <br />item_hlvr_clip_rapidfire=100, item_hlvr_grenade_frag=50, <br />item_hlvr_grenade_xen=50, <br />item_healthvial=100 | Comma separated string to assign chance (0 to 100) for randomized slots
Item Costs<br />(when -1) | item_hlvr_clip_energygun=3, <br />item_hlvr_clip_energygun_multiple=10, <br />item_hlvr_clip_shotgun_multiple=6, <br />item_hlvr_clip_rapidfire=8, item_hlvr_grenade_frag=5, <br />item_hlvr_grenade_xen=5, <br />item_healthvial=5 | Comma separated string to assign cost for item types<br />These only get applied when the slot cost is set to -1

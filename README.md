# cs2-dedicated-updater
Small script to download all important plugins for your dedicated CS2 Server.
Since i personally came often to the issue, simply using "cp" was not really helpful. 
Also always going to all github sites, to download everything by hand is also not really nice.
It helps to not mess up the structure while copying everything into the addons folder

## How To use

copy or download the script to your counterstrike 2 dedicated server (i prefer using path /game/csgo/1_mods)

simply do __bash mm_css_dl.sh__ or __./mm_css_dl.sh__

Choose from the Menu what you want to install

```
echo "Choose an option to download:"
echo "1) Only Metamod"
echo "2) Only Counterstrikesharp"
echo "3) Install both - CSS and Meta"
echo "4) Only ZombieSharp"
echo "5) Only MovementUnlocker"
echo "6) Only MultiAddonManager"
echo "7) Only CS2Fixes"
echo "8) All"
```

Afterwards copy the __addons__ folder into your /game/csgo/ directory and restart your server.

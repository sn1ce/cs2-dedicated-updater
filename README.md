# CS2-dedicated-updater
This script simplifies the process of downloading and organizing key plugins for a dedicated Counter-Strike 2 server. It addresses common issues such as improper use of cp, which can disrupt directory structures, and the inconvenience of manually visiting multiple GitHub repositories to retrieve the latest releases.

By automating the download and extraction process, the script ensures that all components are placed correctly within the addons directory, reducing the risk of misconfiguration and saving valuable setup time.

## What does it do?

- It downloads all latest versions directly from Github

You can also add other plugins, by adding and adjusting something like this:

```
fetch_cs2fixes_url() {
    curl -s https://api.github.com/repos/Source2ZE/CS2Fixes/releases/latest \
    | grep "browser_download_url" \
    | grep "CS2Fixes-v.*-linux.tar.gz" \
    | cut -d '"' -f 4 \
    | head -n 1
}
```

Also you gonna need to add this to the options in the section "case", at the bottom of the script.


## How To use

Copy or download the script to your Counterstrike 2 dedicated server (i prefer using path /game/csgo/1_mods)

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

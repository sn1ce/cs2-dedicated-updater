#!/bin/bash

# Set verbose mode. Change to "true" to enable verbose output.
VERBOSE_MODE="false"

# Define the output directory
OUTPUT_DIR="finished_mm_css_mods"
ADDONS_DIR="$OUTPUT_DIR/addons"

# Create the output directory and addons directory if they don't exist
mkdir -p $ADDONS_DIR
touch $OUTPUT_DIR/blocker

# Function to download and extract a tar.gz file
download_and_extract_tar() {
    local url=$1
    local temp_dir=$2
    local subdir=$3

    local filename=$(basename $url)
    mkdir -p "$temp_dir/$subdir"
    echo "Downloading $filename..."
    curl -s -L -o "$temp_dir/$filename" $url

    if [ "$VERBOSE_MODE" = "true" ]; then
        echo "Extracting $filename to $temp_dir/$subdir..."
        tar -xzvf "$temp_dir/$filename" -C "$temp_dir/$subdir"
    else
        tar -xzf "$temp_dir/$filename" -C "$temp_dir/$subdir"
    fi

    rm "$temp_dir/$filename"
}

# Function to download and extract a zip file
download_and_extract_zip() {
    local url=$1
    local temp_dir=$2
    local subdir=$3

    local filename=$(basename $url)
    mkdir -p "$temp_dir/$subdir"
    echo "Downloading $filename..."
    curl -s -L -o "$temp_dir/$filename" $url

    if [ "$VERBOSE_MODE" = "true" ]; then
        echo "Extracting $filename to $temp_dir/$subdir..."
        unzip "$temp_dir/$filename" -d "$temp_dir/$subdir"
    else
        unzip -q "$temp_dir/$filename" -d "$temp_dir/$subdir"
    fi

    rm "$temp_dir/$filename"
}

# Function to merge all `addons` folders into final output
merge_to_addons() {
    local temp_dir=$1
    echo "Merging contents of $temp_dir to $ADDONS_DIR..."
    find "$temp_dir" -type d -name "addons" | while read addon_dir; do
        cp -rT "$addon_dir" "$ADDONS_DIR"
    done
    rm -r "$temp_dir"
}

# Fetch latest Metamod URL
fetch_metamod_url() {
    curl -s https://www.sourcemm.net/downloads.php?branch=dev \
    | grep -oP 'https://mms.alliedmods.net/mmsdrop/2.0/.*?-linux.tar.gz' \
    | head -n 1
}

# Fetch latest CounterStrikeSharp URL
fetch_css_url() {
    curl -s https://api.github.com/repos/roflmuffin/CounterStrikeSharp/releases/latest \
    | grep "browser_download_url" \
    | grep "counterstrikesharp-with-runtime-linux" \
    | cut -d '"' -f 4 \
    | head -n 1
}

# Fetch latest ZombieSharp URL
fetch_zombiesharp_url() {
    curl -s https://api.github.com/repos/oylsister/ZombieSharp/releases/latest \
    | grep "browser_download_url" \
    | grep "zsharp_stable_.*\.zip" \
    | cut -d '"' -f 4 \
    | head -n 1
}

# Fetch MovementUnlocker
fetch_movementunlocker_url() {
    curl -s https://api.github.com/repos/Source2ZE/MovementUnlocker/releases/latest \
    | grep "browser_download_url" \
    | grep "MovementUnlocker-v.*-linux.tar.gz" \
    | cut -d '"' -f 4 \
    | head -n 1
}

# Fetch MultiAddonManager
fetch_multiaddonmanager_url() {
    curl -s https://api.github.com/repos/Source2ZE/MultiAddonManager/releases/latest \
    | grep "browser_download_url" \
    | grep "MultiAddonManager-v.*-linux.tar.gz" \
    | cut -d '"' -f 4 \
    | head -n 1
}

# Fetch CS2Fixes
fetch_cs2fixes_url() {
    curl -s https://api.github.com/repos/Source2ZE/CS2Fixes/releases/latest \
    | grep "browser_download_url" \
    | grep "CS2Fixes-v.*-linux.tar.gz" \
    | cut -d '"' -f 4 \
    | head -n 1
}

# Fetch CS2 GameModifiers Plugin
fetch_gamemodifiers_url() {
    curl -s https://api.github.com/repos/Lewisscrivens/CS2-GameModifiers-Plugin/releases/latest \
    | grep "browser_download_url" \
    | grep "GameModifiers-v.*\.zip" \
    | cut -d '"' -f 4 \
    | head -n 1
}


echo "Choose an option to download:"
echo "1) Only Metamod"
echo "2) Only Counter-Strike Sharp"
echo "3) Install both - CSS and Meta"
echo "4) Only ZombieSharp"
echo "5) Only MovementUnlocker"
echo "6) Only MultiAddonManager"
echo "7) Only CS2Fixes"
echo "8) Only GameModifiers Plugin"
echo "9) All"
read -p "Enter your choice (1–9): " choice



TEMP_DIR=$(mktemp -d)

case $choice in
    1)
        METAMOD_URL=$(fetch_metamod_url)
        [ -z "$METAMOD_URL" ] && echo "Failed to fetch Metamod URL" && exit 1
        download_and_extract_tar $METAMOD_URL $TEMP_DIR "metamod"
        ;;
    2)
        CSS_URL=$(fetch_css_url)
        [ -z "$CSS_URL" ] && echo "Failed to fetch CounterStrikeSharp URL" && exit 1
        download_and_extract_zip $CSS_URL $TEMP_DIR "counterstrikesharp"
        ;;
    3)
        METAMOD_URL=$(fetch_metamod_url)
        CSS_URL=$(fetch_css_url)

        if [[ -z "$METAMOD_URL" || -z "$CSS_URL" ]]; then
            echo "Failed to fetch Metamod or CounterStrikeSharp URL"
            exit 1
        fi

        download_and_extract_tar $METAMOD_URL $TEMP_DIR "metamod"
        download_and_extract_zip $CSS_URL $TEMP_DIR "counterstrikesharp"
        ;;
    4)
        ZSHARP_URL=$(fetch_zombiesharp_url)
        [ -z "$ZSHARP_URL" ] && echo "Failed to fetch ZombieSharp URL" && exit 1
        download_and_extract_zip $ZSHARP_URL $TEMP_DIR "zombiesharp"
        ;;
    5)
        MU_URL=$(fetch_movementunlocker_url)
        [ -z "$MU_URL" ] && echo "Failed to fetch MovementUnlocker URL" && exit 1
        download_and_extract_tar $MU_URL $TEMP_DIR "movementunlocker"
        ;;
    6)
        MAM_URL=$(fetch_multiaddonmanager_url)
        [ -z "$MAM_URL" ] && echo "Failed to fetch MultiAddonManager URL" && exit 1
        download_and_extract_tar $MAM_URL $TEMP_DIR "multiaddonmanager"
        ;;
    7)
        CS2FIXES_URL=$(fetch_cs2fixes_url)
        [ -z "$CS2FIXES_URL" ] && echo "Failed to fetch CS2Fixes URL" && exit 1
        download_and_extract_tar $CS2FIXES_URL $TEMP_DIR "cs2fixes"
        ;;
    8)
        GMOD_URL=$(fetch_gamemodifiers_url)
        [ -z "$GMOD_URL" ] && echo "Failed to fetch GameModifiers Plugin URL" && exit 1
        download_and_extract_zip $GMOD_URL $TEMP_DIR "gamemodifiers"
        ;;

    9)
        METAMOD_URL=$(fetch_metamod_url)
        CSS_URL=$(fetch_css_url)
        ZSHARP_URL=$(fetch_zombiesharp_url)
        MU_URL=$(fetch_movementunlocker_url)
        MAM_URL=$(fetch_multiaddonmanager_url)
        CS2FIXES_URL=$(fetch_cs2fixes_url)
        GMOD_URL=$(fetch_gamemodifiers_url)

        if [[ -z "$METAMOD_URL" || -z "$CSS_URL" || -z "$ZSHARP_URL" || -z "$MU_URL" || -z "$MAM_URL" || -z "$CS2FIXES_URL" || -z "$GMOD_URL" ]]; then
            echo "Failed to fetch one or more URLs"
            exit 1
        fi

        download_and_extract_tar $METAMOD_URL $TEMP_DIR "metamod"
        download_and_extract_zip $CSS_URL $TEMP_DIR "counterstrikesharp"
        download_and_extract_zip $ZSHARP_URL $TEMP_DIR "zombiesharp"
        download_and_extract_tar $MU_URL $TEMP_DIR "movementunlocker"
        download_and_extract_tar $MAM_URL $TEMP_DIR "multiaddonmanager"
        download_and_extract_tar $CS2FIXES_URL $TEMP_DIR "cs2fixes"
        download_and_extract_zip $GMOD_URL $TEMP_DIR "gamemodifiers"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

merge_to_addons $TEMP_DIR
echo "✅ All selected components downloaded and merged to: $ADDONS_DIR"

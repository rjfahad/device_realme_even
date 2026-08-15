#!/bin/bash
clone_if_missing() {
    local repo="$1" branch="$2" dest="$3"
    if [ ! -d "$dest" ]; then
        echo "Cloning $dest ..."
        git clone --depth=1 "$repo" -b "$branch" "$dest"
    else
        echo "Already exists: $dest"
    fi
}

echo "Checking dependencies"

clone_if_missing https://github.com/LineageOS/android_hardware_mediatek.git lineage-20 ./hardware/mediatek
clone_if_missing https://github.com/rjfahad/kernel_realme_even.git rui2-backupx ./kernel/realme/even
clone_if_missing https://github.com/HyperTeam/android_packages_apps_RealmeParts.git lineage-20 ./packages/apps/RealmeParts
clone_if_missing https://gitlab.com/clangsantoni/zyc_clang.git 14 ./prebuilts/clang/host/linux-x86/mylitle-clang
clone_if_missing https://github.com/rjfahad/vendor_realme_RMX3191-ims.git thirteen ./vendor/realme/RMX3191-ims
clone_if_missing https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git lineage-20 ./device/mediatek/sepolicy_vndr
echo "Done!"

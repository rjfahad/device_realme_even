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
clone_if_missing https://github.com/rjfahad/kernel_realme_even.git los-20 ./kernel/realme/even
clone_if_missing https://github.com/HyperTeam/android_packages_apps_RealmeParts.git lineage-20 ./packages/apps/RealmeParts
clone_if_missing https://github.com/rjfahad/vendor_realme_RMX3191-ims.git thirteen ./vendor/realme/RMX3191-ims
clone_if_missing https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git lineage-20 ./device/mediatek/sepolicy_vndr

# DerpFest common vendor config
clone_if_missing https://github.com/DerpFest-AOSP/vendor_derp.git 13 ./vendor/derp

# Toolchain
CLANG_DIR=./prebuilts/clang/host/linux-x86/greenforce-clang
clone_if_missing https://github.com/greenforce-project/greenforce_clang.git main "$CLANG_DIR"
if [ ! -x "$CLANG_DIR/bin/clang" ]; then
    echo "Downloading greenforce-clang toolchain..."
    (cd "$(dirname "$CLANG_DIR")" && bash "$(basename "$CLANG_DIR")/get_clang.sh")
fi

echo "Done!"

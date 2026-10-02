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
# Toolchain (greenforce clang)
# NOTE: the greenforce_clang *repo* is repo-managed (.repo/local_manifests/roomservice.xml),
# so we must NOT git-clone into it here. The repo only ships the installer scripts;
# the actual binaries are fetched by get_clang.py into $CLANG_DIR.
_GF_TOP="${ANDROID_BUILD_TOP:-$(pwd)}"
CLANG_DIR="${CLANG_DIR:-$_GF_TOP/prebuilts/clang/host/linux-x86/greenforce-clang}"
if [ ! -x "$CLANG_DIR/bin/clang" ]; then
    if [ -f "$CLANG_DIR/get_clang.py" ]; then
        echo "Downloading greenforce-clang toolchain into $CLANG_DIR ..."
        (cd "$CLANG_DIR" && GREENFORCE_INSTALL_DIR="$CLANG_DIR" python3 get_clang.py) \
            || echo "WARNING: greenforce-clang download failed (build will fall back to AOSP clang)"
    else
        echo "WARNING: $CLANG_DIR/get_clang.py not found - run 'repo sync' first"
    fi
else
    echo "Toolchain ready: $CLANG_DIR/bin/clang"
fi
unset _GF_TOP
clone_if_missing https://github.com/rjfahad/vendor_realme_RMX3191-ims.git thirteen ./vendor/realme/RMX3191-ims
clone_if_missing https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git lineage-20 ./device/mediatek/sepolicy_vndr
echo "Done!"

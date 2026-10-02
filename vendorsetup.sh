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
clone_if_missing https://github.com/rjfahad/android_packages_apps_RealmeParts.git lineage-20-fps ./packages/apps/RealmeParts
# Toolchain (greenforce clang)
# NOTE: the greenforce_clang *repo* is repo-managed (.repo/local_manifests/roomservice.xml),
# so we must NOT git-clone into it here. The repo only ships the installer scripts;
# the actual binaries are fetched by get_clang.py into $CLANG_DIR.
_GF_TOP="${ANDROID_BUILD_TOP:-$(pwd)}"
CLANG_DIR="${CLANG_DIR:-$_GF_TOP/prebuilts/clang/host/linux-x86/greenforce-clang}"
if [ ! -x "$CLANG_DIR/bin/clang" ]; then
    if [ -f "$CLANG_DIR/get_clang.py" ]; then
        echo "Downloading greenforce-clang toolchain into $CLANG_DIR ..."
        (cd "$CLANG_DIR" && GREENFORCE_INSTALL_DIR="$CLANG_DIR" python3 get_clang.py) || {
            # Fallback: GitHub API rate-limit (403) - use pinned direct release URL
            _GF_URL=$(grep -o 'https://[^[:space:]]*\.tar\.gz' "$CLANG_DIR/get_latest_url.sh" 2>/dev/null | head -1)
            if [ -n "$_GF_URL" ]; then
                echo "API rate-limited, direct download: $_GF_URL"
                curl -sL "$_GF_URL" -o /tmp/gf-clang.tar.gz \
                    && tar -xzf /tmp/gf-clang.tar.gz -C "$CLANG_DIR" \
                    && rm -f /tmp/gf-clang.tar.gz
            fi
            [ -x "$CLANG_DIR/bin/clang" ] \
                || echo "WARNING: greenforce-clang download failed (build will fall back to AOSP clang)"
        }
    else
        echo "WARNING: $CLANG_DIR/get_clang.py not found - run 'repo sync' first"
    fi
else
    echo "Toolchain ready: $CLANG_DIR/bin/clang"
fi
unset _GF_TOP
clone_if_missing https://github.com/rjfahad/vendor_realme_RMX3191-ims.git thirteen ./vendor/realme/RMX3191-ims
clone_if_missing https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git lineage-20 ./device/mediatek/sepolicy_vndr

# Override security patch level to 2026-08-05
if [ -f build/make/core/version_defaults.mk ]; then
    sed -i 's/PLATFORM_SECURITY_PATCH := 2023-09-01/PLATFORM_SECURITY_PATCH := 2026-08-05/' build/make/core/version_defaults.mk
fi

# Fix undefined module "qti_vibrator_hal_defaults" in QCom vibrator HAL
if [ -f ./vendor/qcom/opensource/vibrator/aidl/Android.bp ]; then
    if grep -q 'qti_vibrator_hal_defaults' ./vendor/qcom/opensource/vibrator/aidl/Android.bp; then
        echo "Patching QCom vibrator HAL (removing undefined defaults)..."
        sed -i '/"qti_vibrator_hal_defaults",/d; /defaults/,/],/d' ./vendor/qcom/opensource/vibrator/aidl/Android.bp
    fi
fi

# Disable crashing HIDL thermal HAL service (VNDK mismatch causes SIGSEGV)
# Vendor thermal daemon (thermal/thermal_manager) still handles thermal management
THERMAL_RC=vendor/realme/even/proprietary/vendor/etc/init/android.hardware.thermal@2.0-service.mtk.rc
if [ -f "$THERMAL_RC" ]; then
    echo "Disabling crashing thermal HIDL HAL..."
    sed -i 's/^service vendor.thermal-hal-2-0.mtk/#service vendor.thermal-hal-2-0.mtk/' "$THERMAL_RC"
fi

echo "Done!"

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
clone_if_missing https://github.com/rjfahad/vendor_realme_RMX2020-ims.git sixteen-qpr1 ./vendor/realme/RMX2020-ims
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

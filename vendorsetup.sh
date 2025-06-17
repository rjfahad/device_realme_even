echo "Remove depencies"
rm -rf device/realme/even
rm -rf kernel/realme/even
rm -rf vendor/realme/even
rm -rf kernel/realme/RMX3191
rm -rf prebuilts/clang/host/linux-x86/mylitle-clang
rm -rf vendor/realme/RMX3191
rm -rf vendor/realme/RMX3191-ims
rm -rf packages/apps/RealmeParts
rm -rf device/mediatek/sepolicy_vndr
echo "Cloning Dependencies"
git clone --depth=1 --recurse-submodule https://github.com/cumaRull/kernel_realme_RMX3191.git -b rui2 ./kernel/realme/RMX3191
git clone --depth=1 https://github.com/HyperTeam/android_packages_apps_RealmeParts.git -b lineage-20 ./packages/apps/RealmeParts
git clone --depth=1 https://github.com/kdrag0n/proton-clang.git -b master ./prebuilts/clang/host/linux-x86/mylitle-clang
git clone --depth=1 https://github.com/cumaRull/vendor_realme_RMX3191.git -b thirteen-rui2-oss ./vendor/realme/RMX3191
git clone --depth=1 https://github.com/cumaRull/vendor_realme_RMX3191-ims.git -b thirteen ./vendor/realme/RMX3191-ims
git clone --depth=1 https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git -b lineage-20 ./device/mediatek/sepolicy_vndr
echo "Done!"


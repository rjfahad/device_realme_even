echo "Remove depencies"
rm -rf kernel/realme/RMX3191
rm -rf prebuilts/clang/host/linux-x86/mylitle-clang
rm -rf ./device/realme/RMX3191-kernel
rm -rf vendor/realme/RMX3191
rm -rf vendor/realme/RMX3191-ims
rm -rf packages/apps/RealmeParts
echo "Cloning Dependencies"
git clone --depth=1 --recurse-submodule https://github.com/cumaRull/kernel_realme_RMX3191.git -b rui2-backupx ./kernel/realme/RMX3191
git clone --depth=1 https://gitlab.com/clangsantoni/zyc_clang.git -b 14 ./prebuilts/clang/host/linux-x86/mylitle-clang
git clone --depth=1 https://github.com/cumaRull/vendor_realme_RMX3191.git -b twelve-rui2 ./vendor/realme/RMX3191
git clone --depth=1 https://github.com/cumaRull/vendor_realme_RMX3191-ims.git -b thirteen ./vendor/realme/RMX3191-ims
git clone --depth=1 https://github.com/HyperTeam/android_packages_apps_RealmeParts.git -b lineage-20 ./packages/apps/RealmeParts
echo "Done!"


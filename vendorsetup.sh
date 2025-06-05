echo "Remove depencies"
rm -rf kernel/realme/RMX3191
rm -rf kernel/realme/even
rm -rf device/realme/even
rm -rf vendor/realme/even
rm -rf vendor/realme/even-ims
rm -rf prebuilts/clang/host/linux-x86/mylitle-clang
rm -rf vendor/realme/RMX3191
rm -rf vendor/realme/RMX3191-ims
rm -rf packages/apps/RealmeParts
rm -rf vendor/gapps
rm -rf packages/apps/RealmeDirac
echo "Cloning Dependencies"
git clone --recurse-submodule https://github.com/cumaRull/kernel_realme_RMX3191.git -b rui2 ./kernel/realme/RMX3191
git clone https://github.com/kdrag0n/proton-clang.git -b master ./prebuilts/clang/host/linux-x86/mylitle-clang
git clone https://github.com/cumaRull/vendor_realme_RMX3191.git -b twelve-rui2 ./vendor/realme/RMX3191
git clone https://github.com/cumaRull/vendor_realme_RMX3191-ims.git -b twelve ./vendor/realme/RMX3191-ims
git clone https://github.com/Realme-C25-Series-Development/android_packages_apps_RealmeParts.git -b aosp12 ./packages/apps/RealmeParts
git clone https://gitlab.com/MindTheGapps/vendor_gapps.git -b sigma ./vendor/gapps
echo "Done!"


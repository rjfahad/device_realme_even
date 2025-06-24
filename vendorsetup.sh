echo "Remove depencies"
rm -rf kernel/realme/RMX3191
rm -rf prebuilts/clang/host/linux-x86/mylitle-clang
rm -rf vendor/realme/RMX3191
rm -rf vendor/realme/RMX3191-ims
rm -rf packages/apps/RealmeParts
rm -rf hardware/mediatek
rm -rf packages/apps/RealmeDirac
rm -rf ./device/realme/RMX3191-kernel

echo "Cloning Dependencies"
git clone https://github.com/cumaRull/kernel_realme_RMX3191-prebuilt.git -b RUI2-OSS ./device/realme/RMX3191-kernel
git clone --recurse-submodule https://github.com/cumaRull/kernel_realme_RMX3191.git -b suki-dev ./kernel/realme/RMX3191
git clone https://gitlab.com/clangsantoni/zyc_clang.git -b 14 ./prebuilts/clang/host/linux-x86/mylitle-clang
git clone https://github.com/cumaRull/vendor_realme_RMX3191.git -b twelve-rui2 ./vendor/realme/RMX3191
git clone https://github.com/cumaRull/vendor_realme_RMX3191-ims.git -b twelve ./vendor/realme/RMX3191-ims
git clone https://github.com/Realme-C25-Series-Development/android_packages_apps_RealmeParts.git -b aosp12 ./packages/apps/RealmeParts
git clone https://github.com/cumaRull/android_hardware_mediatek.git -b lineage-20 ./hardware/mediatek
echo "Done!"


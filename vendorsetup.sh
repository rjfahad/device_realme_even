echo "Remove depencies"
rm -rf device/realme/even
rm -rf kernel/realme/even
rm -rf vendor/realme/even
rm -rf kernel/realme/RMX3191
rm -rf device/realme/RMX3191-kernel
rm -rf prebuilts/clang/host/linux-x86/mylitle-clang
rm -rf vendor/realme/RMX3191
rm -rf vendor/realme/RMX3191-ims
rm -rf packages/apps/RealmeParts
rm -rf device/mediatek/sepolicy_vndr
echo "Cloning Dependencies"
git clone --depth=1 https://github.com/cumaRull/kernel_realme_RMX3191-prebuilt.git -b RUI2-OSS ./device/realme/RMX3191-kernel
# git clone --depth=1 https://github.com/kdrag0n/proton-clang.git -b master ./prebuilts/clang/host/linux-x86/mylitle-clang
git clone --depth=1 https://github.com/cumaRull/vendor_realme_RMX3191.git -b oss-rui2-dev ./vendor/realme/RMX3191
git clone --depth=1 https://github.com/cumaRull/vendor_realme_RMX3191-ims.git -b twelve ./vendor/realme/RMX3191-ims
git clone --depth=1 https://github.com/cumaRull/android_device_mediatek_sepolicy_vndr.git -b lineage-19.1 ./device/mediatek/sepolicy_vndr
echo "Done!"


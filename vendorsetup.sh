echo "starting depencies"
echo "REMOVING UNUSED DEPENCIES"
rm -rf ./hardware/oplus/interfaces/
rm -rf ./vendor/realme/RMX3191-ims
rm -rf ./vendor/realme/even-ims
rm -rf ./vendor/realme/RMX3191
rm -rf ./vendor/realme/even
rm -rf ./device/realme/even
rm -rf ./hardware/mediatek/InCallService
rm -rf ./device/realme/RMX3191-kernel
rm -rf packages/apps/RealmeParts
rm -rf hardware/oplus
rm -rf hardware/mediatek
rm -rf kernel/realme/RMX3191
echo "succesfully"

echo "clone vt"
git clone https://github.com/cumaRull/vendor_realme_RMX3191.git -b lineage-20.0 ./vendor/realme/RMX3191
echo "successfully"
echo "clone Kernel prebuilt"
git clone --depth=1 https://github.com/kdrag0n/proton-clang.git -b master ./prebuilts/clang/host/linux-x86/mylitle-clang
git clone --recurse-submodules https://github.com/Badmaneers/kernel_realme_even.git --depth=1 kernel/realme/RMX3191
#git clone https://github.com/HyperTeam/android_packages_apps_RealmeParts.git -b lineage-20 ./packages/apps/RealmeParts
git clone https://github.com/LineageOS/android_hardware_oplus.git -b lineage-22.1 ./hardware/oplus
git clone https://github.com/cumaRull/android_hardware_mediatek.git -b lineage-22.1 ./hardware/mediatek

rm -rf ./hardware/mediatek/InCallService
rm -rf ./hardware/oplus/interfaces/

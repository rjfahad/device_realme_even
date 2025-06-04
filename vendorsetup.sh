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
echo "succesfully"

echo "clone vt"
git clone https://github.com/cumaRull/vendor_realme_RMX3191.git -b rui4-oss ./vendor/realme/RMX3191
echo "successfully"
echo "clone Kernel prebuilt"
git clone https://github.com/cumaRull/kernel_realme_RMX3191-prebuilt.git -b master ./device/realme/RMX3191-kernel
git clone https://github.com/HyperTeam/android_packages_apps_RealmeParts.git -b lineage-20 ./packages/apps/RealmeParts
git clone https://github.com/LineageOS/android_hardware_oplus.git -b lineage-20 ./hardware/oplus
git clone https://github.com/LineageOS/android_hardware_mediatek.git -b lineage-20 ./hardware/mediatek

rm -rf ./hardware/mediatek/InCallService
rm -rf ./hardware/oplus/interfaces/
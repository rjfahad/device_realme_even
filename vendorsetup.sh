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
echo "succesfully"

echo "clone vt"
git clone https://github.com/cumaRull/vendor_realme_RMX3191.git -b lineage-20.0 ./vendor/realme/RMX3191
echo "successfully"
echo "clone Kernel prebuilt"
git clone --depth=1 https://github.com/cumaRull/kernel_realme_RMX3191-prebuilt.git -b master ./device/realme/RMX3191-kernel

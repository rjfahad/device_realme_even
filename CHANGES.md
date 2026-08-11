# RMX3191 LineageOS Build - Changes Log

## SELinux Policy Fixes

### sepolicy/vendor/vendor_init.te
- Added get_prop/set_prop for system_oplus_fingerprint_prop (fingerprint fp_id at boot)
- Added get_prop for system_oplus_sensor_prop

### sepolicy/vendor/init.te
- Added proc_tp:file rw_file_perms (touchpanel)
- Added proc_oplus_ver:file r_file_perms, proc_oplus_fp:file rw_file_perms
- Added sysfs:file { write open } for kernel_init_done, cmode, rps_cpus, read_ahead_kb
- Added sysfs_usb_nonplat, sysfs_net, sysfs_devices_block write access
- Added sysfs_sensor:file setattr

### sepolicy/vendor/cameraserver.te
- Added get_prop(cameraserver, vendor_mtk_audio_prop)

### sepolicy/vendor/system_app.te
- Added proc_tp dir search and file rw_file_perms access

### sepolicy/vendor/file.te (new type declarations)
- Declared sysfs_light, sysfs_graphics types (mlstrustedobject)

### sepolicy/vendor/hal_light_default.te (NEW)
- sysfs_light and sysfs_graphics search + rw_file_perms

### sepolicy/vendor/genfs_contexts
- Added 7 genfscon entries for light HAL sysfs nodes (leds, backlight)

### sepolicy/vendor/rild.te
- Added get_prop(rild, default_prop)
- Added allow rild metadata_file:file r_file_perms

### sepolicy/vendor/hal_wifi_default.te
- Reverted to empty (vendor_wlan_fw_prop type doesn't exist)

### Files REMOVED
- sepolicy/vendor/system_suspend.te (system_suspend is a platform type, not available in vendor sepolicy)

## WiFi Driver Loading Fixes

### IMPORTANT: CONFIG_WLAN_DRV_BUILD_IN=y
- Kernel is built with `CONFIG_WLAN_DRV_BUILD_IN=y` — WiFi driver is compiled INTO the kernel
- Stock `.ko` files from dump are USELESS (compiled for 4.14.186, kernel is 4.14.282-TridentNotDeath)
- Vermagic mismatch causes `Exec format error` at boot when kernel tries to load them
- Do NOT ship `.ko` files — they cause boot-time module loading failures

### proprietary-files.txt
- Commented out `wmt_chrdev_wifi.ko`, `wlan_drv_gen4m.ko`, `wmt_drv.ko`
- These stock modules are compiled for 4.14.186 and fail with vermagic mismatch on 4.14.282

### RMX3191-vendor.mk
- Removed copy rules for `wmt_chrdev_wifi.ko` and `wlan_drv_gen4m.ko`

### vendor/realme/RMX3191/proprietary/vendor/lib/modules/
- Deleted `wmt_chrdev_wifi.ko`, `wlan_drv_gen4m.ko`, `wmt_drv.ko` from source tree

### rootdir/etc/init.wlan_drv.rc
- Triggers on `vendor.connsys.driver.ready=yes`
- Starts `wlan_assistant` service (no insmod needed, driver is built-in)

### rootdir/Android.bp
- Added prebuilt_etc module for `init.wlan_drv.rc` (installed to `/vendor/etc/init/`)

### device.mk
- Added `init.wlan_drv.rc` to PRODUCT_PACKAGES

### rootdir/etc/init.connectivity.rc
- Added `wpa_supplicant` service definition (was completely missing)
- Matches RMX2020 working configuration
- Removed duplicate wmt_loader/wmt_launcher/wlan_assistant definitions (vendor blob's init_connectivity.rc already defines them with class early_hal)

### rootdir/etc/init.mt6768.rc
- Removed broken imports: `init.volte.rc` and `init.mal.rc` (files don't exist)

### configs/manifests/manifest.xml
- Added missing WiFi HIDL HAL entries:
  - `android.hardware.wifi@1.0/1.3::IWifi/default`
  - `android.hardware.wifi.hostapd@1.1::IHostapd/default`
  - `android.hardware.wifi.supplicant@1.2::ISupplicant/default`
  - `vendor.mediatek.hardware.wifi.hostapd@2.0::IHostapd/default`

### configs/props/vendor.prop
- Added `wifi.interface=wlan0` property

### sepolicy/vendor/hal_wifi_default.te
- Added get_prop/set_prop for vendor_wlan_fw_prop and vendor_mtk_wifi_hotspot_prop

### sepolicy/vendor/hal_wifi_hostapd_default.te (NEW)
- Allow hal_wifi_hostapd_default to add/find hostapd hwservice

### sepolicy/vendor/mtk_hal_wifi.te (NEW)
- get_prop/set_prop for vendor_mtk_wifi_hal_prop

### Recovery flashable zip
- Created `rmx3191-wifi-fix.zip` at `/home/fahad/android/rmx3191-audio-wifi-flash/`
- Flashes audio HAL blobs + corrected init rc files
- No kernel modules — driver is built-in, shipping wrong .ko files causes Exec format error

## WiFi Changes Reverted

### 2026-08-11
- All WiFi-related changes from today reverted
- Reason: WiFi HAL service binary (`android.hardware.wifi@1.0-service`) missing from vendor, manifest entries alone don't fix WiFi
- Files reverted: manifest.xml (removed WiFi HALs), vendor.prop (removed wifi.interface), init.connectivity.rc (removed wpa_supplicant), init.mt6768.rc (restored volte/mal imports), init.wlan_drv.rc (restored insmod), hal_wifi_default.te, hal_wifi_hostapd_default.te (deleted), mtk_hal_wifi.te (deleted)
- WiFi .ko modules restored to vendor tree (wmt_chrdev_wifi.ko, wlan_drv_gen4m.ko, wmt_drv.ko)

## Audio HAL Fixes

### vendor/lib[64]/hw/audio.primary.mt6768.so (REPLACED)
- Vendor blobs had wrong version: linked to `libalsautils-v30.so` (VNDK-versioned) which doesn't exist
- Stock dump version links to plain `libalsautils.so` (matches available `libalsautils-mtk.so` / built `libalsautils.so`)
- Root cause: blobs were from a different ROM build (different MD5 checksums)

### vendor/lib[64]/hw/audio.usb.mt6768.so (REPLACED)
- Same VNDK versioning mismatch as audio.primary
- Replaced with stock dump versions

### vendor/lib[64]/libmedia_helper.so (ADDED)
- Stock `audio.primary.mt6768.so` requires `android::TypeConverter<audio_format_t>::mTable` symbol
- Symbol is defined in stock `libmedia_helper.so` (system) but missing from LineageOS's built version
- Copied stock `libmedia_helper.so` (32+64-bit) to vendor namespace so audio HAL resolves the symbol

### sepolicy/vendor/audioserver.te
- Added `get_prop(audioserver, vendor_default_prop)` — audioserver was denied read access to vendor_default_prop at boot

### Recovery flashable zip
- Created `rmx3191-audio-wifi-flash.zip` at `/home/fahad/android/` for custom recovery (TWRP)
- Recovery mounts `/vendor` rw directly, bypassing dm-linear readonly issue
- Flashes all audio + WiFi fixes in one zip

## Init RC Fixes

### rootdir/etc/init.project.rc (NEW)
- Camera AF device nodes (GAF001AF, DW9714AF, LC898212AF, BU64745GWZAF)
- Camera persist directory
- Touchpanel firmware 20561 directory
- Flashlight sysfs permissions (flash1/2/3)
- SMB ScreenComm permissions
- fuse_usbotg service

### rootdir/etc/init.mt6768.rc
- Added import vendor/etc/init/hw/init.project.rc

### rootdir/Android.bp
- Added prebuilt_etc module definition for init.project.rc

### device.mk
- Added init.project.rc to PRODUCT_PACKAGES

## Vendor HAL Crash Fixes

### vendor/etc/init/vendor.mediatek.hardware.dfps@1.0-service.rc
- Added disabled + oneshot (VNDK33 RefBase ABI mismatch - incStrongRequireStrong crash loop)

### vendor/etc/init/vendor.mediatek.hardware.pq@2.2-service.rc
- Added disabled + oneshot (same VNDK33 issue)

## Build Fixes

### vendor/realme/RMX3191/Android.bp
- Removed prebuilt_etc_xml for manifest_android.hardware.drm@1.4-service.widevine (manifest XML missing)
- Removed cc_prebuilt_library_shared for libcam3a_imem (lib missing from stock dump)

### vendor/realme/RMX3191/RMX3191-vendor.mk
- Removed all copy-file entries for missing blobs (29 files):
  - Widevine DRM service, manifest, rc
  - libcam3a_imem.so
  - pascali camera CCU calibration files (dm/pm)
  - pascali camera tuning libs (IdxMgr/tuning .so)
  - libcdsprpc.so (DSP compute)
  - APDB_MT6768_S01__W2106 and _ENUM
  - Touchpanel 20761 firmware (ILI7807S/ILI9882N)
- Removed manifest_android.hardware.drm@1.4-service.widevine from PRODUCT_PACKAGES

## Host Build Fix

### prebuilts/clang/host/linux-x86/clang-3289846/lib64/libtinfo.so.5
- Symlink to /usr/lib/x86_64-linux-gnu/libtinfo.so.6 (system only has libtinfo.so.6)

### out/host/linux-x86/lib64/libtinfo.so.5
- Same symlink for bcc_strip_attr (host renderscript tool)

### prebuilts/clang/host/linux-x86/clang-3289846/bin/clang.real
- patchelf rpath updated to include lib64 path

## vendorsetup.sh
- Changed from destructive (rm -rf all then re-clone) to clone_if_missing (skip existing dirs)
- Removed cleanup of RMX3191 vendor/kernel dirs
- Only cleans leftover "even" device dirs

## Camera HAL Fixes

### vendor/lib[64]/libunwindstack.so (ADDED)
- Stock `vendor/lib64/libudf.so` requires `unwindstack::Elf::GetRelPc(unsigned long, const unwindstack::MapInfo*)` — the `const` signature
- LineageOS-built `system/lib64/libunwindstack.so` only exports the non-const signature: `GetRelPc(unsigned long, unwindstack::MapInfo*)`
- Result: `camerahalserver` crashes in a loop with "CANNOT LINK EXECUTABLE" linker error
- Fix: ship stock `libunwindstack.so` to `vendor/lib[64]/` so it's found before the system version

### sepolicy/vendor/property_contexts
- Added `ro.mtk_cam.` label → `vendor_oplus_camera_prop`
- Fixes SELinux denial: "Do not have permissions to set 'ro.mtk_cam_stereo_camera_support'"

### odm/etc/camera/ calibration files (ADDED)
- MTK NSCam HAL requires sensor calibration/inputparam files to enumerate cameras
- Without these, HAL returns zero sensors → camera app shows "Use cases not attached to camera"
- Files copied from stock ODM dump:
  - `mtCalibrationCfg.xml` — main camera calibration config
  - `mtInputparam.xml` — main camera input parameters
  - `mwCalibrationCfg.xml` — multi-window calibration config
  - `mwInputparam.xml` — multi-window input parameters
  - `stereoParams.bin` — stereo/depth camera parameters
  - `engineer_camera_config` — camera engineer mode config
- Added to proprietary-files.txt and RMX3191-vendor.mk (TARGET_COPY_OUT_ODM)

### vendor/lib[64]/evenc_* sensor libs (ADDED)
- `libcameracustom.so` requires the `evenc` variant sensor libs (not `even` variant)
- Missing libs cause: `dlopen failed: evenc_shinetech_depth_gc02m1b_IdxMgr.so not found`
- 12 files added (6 lib + 6 lib64):
  - `evenc_shengtai_front_ov8856_IdxMgr.so` + `_tuning.so`
  - `evenc_shengtai_macro_ov02b10_IdxMgr.so` + `_tuning.so`
  - `evenc_shinetech_depth_gc02m1b_IdxMgr.so` + `_tuning.so`

### vendor/lib[64]/even_shinetech_main_s5kjn103_* (ADDED)
- Missing sensor module manager and tuning lib for main camera
- `even_shinetech_main_s5kjn103_IdxMgr.so` + `_tuning.so` (lib + lib64)

### vendor/lib[64]/liboppo_platform_hwi.so lib64 (ADDED)
- Only 32-bit version existed, 64-bit was missing
- Required by `libmtkcam_hwnode.so`

### net result: 3 cameras detected
- Camera HAL loads all sensor modules successfully
- `dumpsys media.camera` reports 3 cameras

## Missing Blobs (documented in device/realme/RMX3191/missing_blobs.txt)
- Widevine DRM service + manifest + rc (3 files)
- libcam3a_imem.so
- pascali camera variant CCU + tuning libs (20 files)
- APDB variants (2 files)
- Touchpanel 20761 firmware (6 files)
- libcdsprpc.so

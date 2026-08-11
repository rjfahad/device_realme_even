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

### vendor/lib/modules/wmt_chrdev_wifi.ko (NEW)
- Copied from stock dump — WMT WiFi character device module, prerequisite for wlan driver

### RMX3191-vendor.mk
- Added copy-file entries for `wmt_chrdev_wifi.ko` and `wlan_drv_gen4m.ko` (neither was listed before; wlan_drv existed in proprietary but wasn't being installed)

### rootdir/etc/init.wlan_drv.rc (NEW)
- Triggers on `vendor.connsys.driver.ready=yes`
- insmod `wmt_chrdev_wifi.ko`, then `wlan_drv_gen4m.ko`
- Starts `wlan_assistant` service
- Matches stock `init.wlan_drv.rc` behavior

### rootdir/Android.bp
- Added prebuilt_etc module for `init.wlan_drv.rc` (installed to `/vendor/etc/init/`)

### device.mk
- Added `init.wlan_drv.rc` to PRODUCT_PACKAGES

## Audio HAL Fixes

### vendor/lib[64]/hw/audio.primary.mt6768.so (REPLACED)
- Vendor blobs had wrong version: linked to `libalsautils-v30.so` (VNDK-versioned) which doesn't exist
- Stock dump version links to plain `libalsautils.so` (matches available `libalsautils-mtk.so` / built `libalsautils.so`)
- Root cause: blobs were from a different ROM build (different MD5 checksums)

### vendor/lib[64]/hw/audio.usb.mt6768.so (REPLACED)
- Same VNDK versioning mismatch as audio.primary
- Replaced with stock dump versions

### sepolicy/vendor/audioserver.te
- Added `get_prop(audioserver, vendor_default_prop)` — audioserver was denied read access to vendor_default_prop at boot

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

## Missing Blobs (documented in device/realme/RMX3191/missing_blobs.txt)
- Widevine DRM service + manifest + rc (3 files)
- libcam3a_imem.so
- pascali camera variant CCU + tuning libs (20 files)
- APDB variants (2 files)
- Touchpanel 20761 firmware (6 files)
- libcdsprpc.so

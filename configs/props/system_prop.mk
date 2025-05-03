# Camera
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.vendor.camera.privapp.list=org.lineageos.aperture,com.android.camera,com.google.camera \
    vendor.camera.aux.packagelist=org.lineageos.aperture,com.android.camera,com.google.camera \
    vendor.camera.aux.packageblacklist=org.telegram.messenger,com.microsoft.teams,com.discord

# MediaTek Perf Enhancements
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.mtk_perf_simple_start_win=1 \
    ro.mtk_perf_fast_start_win=1 \
    ro.mtk_perf_response_time=1

# Privapp permissions whitelisting
PRODUCT_PRODUCT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Audio
PRODUCT_PRODUCT_PROPERTIES += \
    ro.camera.sound.forced=0 \
    ro.audio.silent=0 \
    ro.config.vc_call_vol_steps=9

# Bluetooth
PRODUCT_PRODUCT_PROPERTIES += \
   bluetooth.profile.a2dp.source.enabled=true \
   bluetooth.profile.asha.central.enabled=true \
   bluetooth.profile.avrcp.target.enabled=true \
   bluetooth.profile.bas.client.enabled=true \
   bluetooth.profile.gatt.enabled=true \
   bluetooth.profile.hfp.ag.enabled=true \
   bluetooth.profile.hid.device.enabled=true \
   bluetooth.profile.hid.host.enabled=true \
   bluetooth.profile.map.server.enabled=true \
   bluetooth.profile.opp.enabled=true \
   bluetooth.profile.pan.nap.enabled=true \
   bluetooth.profile.pan.panu.enabled=true \
   bluetooth.profile.pbap.server.enabled=true \
   bluetooth.profile.sap.server.enabled=false

PRODUCT_SYSTEM_PROPERTIES += \
    persist.bluetooth.system_audio_hal.enabled=true \
    persist.bluetooth.bluetooth_audio_hal.disabled=false \
    persist.bluetooth.a2dp_offload.disabled=true \
    ro.bluetooth.a2dp_offload.supported=false

# VoNR (Voice Over New radio)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.radio.is_vonr_enabled_0=true \
    persist.radio.is_vonr_enabled_1=true
    
# PM service
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \ 
   pm.dexopt.ab-ota=speed-profile \
   pm.dexopt.bg-dexopt=speed-profile \
   pm.dexopt.boot-after-ota=verify \
   pm.dexopt.cmdline=verify \
   pm.dexopt.first-boot=verify \
   pm.dexopt.inactive=verify \
   pm.dexopt.install=speed-profile \
   pm.dexopt.install-bulk=speed-profile \
   pm.dexopt.install-bulk-downgraded=verify \
   pm.dexopt.install-bulk-secondary=verify \
   pm.dexopt.install-bulk-secondary-downgraded=extract \
   pm.dexopt.install-fast=skip \
   pm.dexopt.post-boot=extract \
   pm.dexopt.shared=speed   

# Debug and Dalvik service
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \ 
   Build.BRAND=MTK \
   dalvik.vm.appimageformat=lz4 \
   dalvik.vm.dex2oat-Xms=64m \
   dalvik.vm.dex2oat-Xmx=512m \
   dalvik.vm.dex2oat-max-image-block-size=524288 \
   dalvik.vm.dex2oat-minidebuginfo=true \
   dalvik.vm.dex2oat-resolve-startup-strings=true \
   dalvik.vm.dexopt.secondary=true \
   dalvik.vm.dexopt.thermal-cutoff=2 \
   dalvik.vm.image-dex2oat-Xms=64m \
   dalvik.vm.image-dex2oat-Xmx=64m \
   dalvik.vm.madvise.artfile.size=4294967295 \
   dalvik.vm.madvise.odexfile.size=104857600 \
   dalvik.vm.madvise.vdexfile.size=104857600 \
   dalvik.vm.minidebuginfo=true \
   dalvik.vm.ps-min-first-save-ms=150000 \
   dalvik.vm.usejit=true \
   dalvik.vm.usejitprofiles=true \
   debug.atrace.tags.enableflags=0 \
   debug.sf.early.app.duration=20000000 \
   debug.sf.early.sf.duration=27600000 \
   debug.sf.earlyGl.app.duration=20000000 \
   debug.sf.earlyGl.sf.duration=27600000 \
   debug.sf.enable_transaction_tracing=false \
   debug.sf.hwc.min.duration=23000000 \
   debug.sf.latch_unsignaled=true \
   debug.sf.late.app.duration=20000000 \
   debug.sf.late.sf.duration=27600000 \
   debug.sf.predict_hwc_composition_strategy=0 \
   debug.sf.use_phase_offsets_as_durations=1 \
   debug.stagefright.c2inputsurface=-1 \
   hbt.debug=off \
   media.stagefright.thumbnail.prefer_hw_codecs=true \
   mediatek.wlan.ctia=0 \
   net.bt.name=Android
   
# Persist
PRODUCT_SYSTEM_PROPERTIES += \
  persist.log.tag.BufferQueueDump=I \
  persist.log.tag.BufferQueueProducer=I \
  persist.log.tag.GraphicBuffer=I \
  persist.log.tag.SurfaceControl=I \
  persist.sys.fuse.passthrough.enable=true \
  persist.traced.enable=1 \
  persist.vendor.mdlog.flush_log_ratio=0 \
  persist.vendor.pms_removable=1 \
  persist.vendor.vzw_device_type=0 \
  persist.vendor.wfc.sys_wfc_support=1 
  
# Misc
PRODUCT_SYSTEM_PROPERTIES += \
  qemu.hw.mainkeys=0 \
  ro.actionable_compatible_property.enabled=true \
  ro.allow.mock.location=0 \
  ro.audio.usb.period_us=16000 \
  ro.config.per_app_memcg=false \
  ro.dalvik.vm.native.bridge=0 \
  ro.iorapd.enable=false \
  ro.kernel.zio=38,108,105,16 \
  ro.mediatek.version.branch=alps-mp-t0.mssi1.tc16sp-pr2 \
  ro.mediatek.version.release=alps-mp-t0.mp1.tc16sp-pr2-V1 \
  ro.mediatek.wlan.p2p=1 \
  ro.mediatek.wlan.wsc=1 \
  ro.opengles.version=196610 \
  ro.support_one_handed_mode=true 
  ro.sys.usb.bicr=no \
  ro.sys.usb.charging.only=yes \
  ro.sys.usb.mtp.whql.enable=0 \
  ro.sys.usb.storage.type=mtp \
  ro.vendor.customer_logpath=/data \
  ro.vendor.have_aee_feature=1 \
  ro.vendor.mtk_cta_set=1 \
  ro.vendor.mtk_flv_playback_support=1 \
  ro.vendor.mtk_gwsd_support=1 \
  ro.vendor.mtk_omacp_support=1 \
  ro.vendor.mtk_power_off_alarm_test=1 \
  ro.vendor.mtk_telephony_add_on_policy=0 \
  ro.vendor.qti.va_aosp.support=0 \
  ro.zygote.preload.enable=0 \
  security.perf_harden=1 \
  sys.ipo.disable=1 \
  sys.ipo.pwrdncap=2 \
  vendor.af.threshold.src_and_effect_count=5 \
  vendor.mtk_thumbnail_optimization=true \
  vendor.rild.libargs=-d /dev/ttyC0 \
  vendor.rild.libpath=mtk-ril.so \
  wifi.direct.interface=p2p0 \
  wifi.interface=wlan0 \
  wifi.tethering.interface=ap0 

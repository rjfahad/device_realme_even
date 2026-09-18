#
# Copyright (C) 2022 The DerpFest Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

#
# All components inherited here go to system_ext image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

# Inherit from device makefile
$(call inherit-product, device/realme/even/device.mk)

# Vanilla (non-GMS) build: honored by the WITH_GMS guard in
# vendor/derp/config/common.mk (applied via patches/ on lunch).
WITH_GMS := false

# Inherit some common DerpFest stuff.
$(call inherit-product, vendor/derp/config/common.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := derp_even
PRODUCT_DEVICE := even
PRODUCT_BRAND := realme
PRODUCT_MANUFACTURER := realme
PRODUCT_MODEL := RMX3191

PRODUCT_SYSTEM_MODEL := even
PRODUCT_SYSTEM_NAME := even
PRODUCT_SYSTEM_DEVICE := even

TARGET_BOOT_ANIMATION_RES := 720

PRODUCT_GMS_CLIENTID_BASE := android-realme

# DerpFest Official
DERP_BUILDTYPE := Official

# Build info - overridden at boot by init.cpp based on ro.boot.prjname
PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceName=even \
    DeviceProduct=even

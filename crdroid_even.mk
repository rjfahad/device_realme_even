#
# Copyright (C) 2022 The crDroid Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile
$(call inherit-product, device/realme/even/device.mk)

# Inherit some common crDroid stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := crdroid_even
PRODUCT_DEVICE := even
PRODUCT_BRAND := realme
PRODUCT_MANUFACTURER := realme
PRODUCT_MODEL := even

PRODUCT_SYSTEM_MODEL := even
PRODUCT_SYSTEM_NAME := even
PRODUCT_SYSTEM_DEVICE := even

TARGET_BOOT_ANIMATION_RES := 720

PRODUCT_GMS_CLIENTID_BASE := android-realme

# Build info - overridden at boot by init.cpp based on ro.boot.prjname
PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceName=even \
    DeviceProduct=even

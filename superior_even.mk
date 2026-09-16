#
# Copyright (C) 2023 The SuperiorOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile
$(call inherit-product, device/realme/even/device.mk)

# Inherit some common Superior stuff.
$(call inherit-product, vendor/superior/config/common.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := superior_even
PRODUCT_DEVICE := even
PRODUCT_BRAND := realme
PRODUCT_MANUFACTURER := realme
PRODUCT_MODEL := even

PRODUCT_SYSTEM_MODEL := even
PRODUCT_SYSTEM_NAME := even
PRODUCT_SYSTEM_DEVICE := even

TARGET_BOOT_ANIMATION_RES := 720

# GMS disabled by default
BUILD_WITH_GAPPS := false

# Build info
PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceName=even \
    DeviceProduct=even

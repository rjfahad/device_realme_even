#
# Copyright (C) 2020 Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# Inherit from device makefile
$(call inherit-product, device/realme/RMX3191/device.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := lineage_RMX3191
PRODUCT_DEVICE := RMX3191
PRODUCT_BRAND := realme
PRODUCT_MODEL := realme c25
PRODUCT_MANUFACTURER := realme
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_BOOT_ANIMATION_RES := 720


# LineageOS ext
TARGET_GAPPS_ARCH := arm64
LINEAGE_BUILDTYPE := GAPPS

PRODUCT_GMS_CLIENTID_BASE := android-realme

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="sys_mssi_64_cn_armv82-user 13 TP1A.220905.001 1716367279348 release-keys"

BUILD_FINGERPRINT := realme/RMX3191/RMX3191:13/TP1A.220905.001/1716367279348:user/release-keys

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)

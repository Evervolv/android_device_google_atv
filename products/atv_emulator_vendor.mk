#
# Copyright (C) 2020 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file is included by other product makefiles to add all the
# TV emulator-related modules to PRODUCT_PACKAGES.
#

EMULATOR_VENDOR_NO_GNSS := true
EMULATOR_VENDOR_NO_BIOMETRICS := true
EMULATOR_VENDOR_NO_SENSORS := true

ifneq ($(PRODUCT_IS_ATV_ARM64_SDK),true)
    $(call inherit-product, device/google/atv/products/atv_vendor.mk)
endif

# Sets HDMI CEC as Playback Device.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.device_type=4 \
    ro.hdmi.cec_device_types=playback_device

# need this for gles libraries to load properly
# after moving to /vendor/lib/
PRODUCT_PACKAGES += \
    vndk-sp

DEVICE_PACKAGE_OVERLAYS += \
    device/google/atv/sdk_overlay \
    development/sdk_overlay

# Declared in emulator64_vendor.mk for 64-bit targets.
ifneq ($(PRODUCT_IS_ATV_ARM64_SDK),true)
    DEVICE_PACKAGE_OVERLAYS += \
        device/generic/goldfish/overlay
endif

PRODUCT_CHARACTERISTICS := emulator

PRODUCT_COPY_FILES += \
    device/generic/goldfish/data/etc/config.ini.tv:config.ini

PRODUCT_COPY_FILES += \
    device/generic/goldfish/camera/media/media_codecs_google_tv.xml:${TARGET_COPY_OUT_VENDOR}/etc/media_codecs_google_tv.xml \
    device/generic/goldfish/data/etc/apns-conf.xml:$(TARGET_COPY_OUT_VENDOR)/etc/apns-conf.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    hardware/libhardware_legacy/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf

# Exclude all non-default hardware features on ATV SDK.
# All default supported features are defined via device/google/atv/permissions/tv_core_hardware.xml.
PRODUCT_COPY_FILES += \
    device/google/atv/permissions/tv_sdk_excluded_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tv_sdk_excluded_core_hardware.xml

# goldfish vendor partition configurations
$(call inherit-product, device/generic/goldfish/product/generic.mk)

#watchdog tiggers reboot because location service is not
#responding, disble it for now.
#still keep it on internal master as it is still working
#once it is fixed in aosp, remove this block of comment.
#PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
#config.disable_location=true

# enable Google-specific location features,
# like NetworkLocationProvider and LocationCollector
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.com.google.locationfeatures=1

# disable setupwizard
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.setupwizard.mode=DISABLED

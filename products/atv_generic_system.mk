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

# This makefile is the basis of a generic system image for a TV device.
$(call inherit-product, device/google/atv/products/atv_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_default.mk)
# Add adb keys to debuggable AOSP builds (if they exist)
$(call inherit-product-if-exists, vendor/google/security/adb/vendor_key.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# OTA support
PRODUCT_PACKAGES += \
    recovery-refresh \
    update_engine \
    update_verifier \

# Wrapped net utils for /vendor access.
PRODUCT_PACKAGES += netutils-wrapper-1.0

# system_other support
PRODUCT_PACKAGES += \
    cppreopts.sh \
    otapreopt_script

# System libraries commonly depended on by things on the system_ext or product partitions.
# These lists will be pruned periodically.
PRODUCT_PACKAGES += \
    android.hardware.wifi \
    libaudio-resampler \
    libaudiohal \
    libdrm \
    liblogwrap \
    liblz4 \
    libminui \
    libnl \
    libprotobuf-cpp-full

# These libraries are empty and have been combined into libhidlbase, but are still depended
# on by things off /system.
# TODO(b/135686713): remove these
PRODUCT_PACKAGES += \
    libhidltransport \
    libhwbinder

PRODUCT_PACKAGES_ENG += \
    avbctl \
    bootctl \
    tinycap \
    tinyhostless \
    tinymix \
    tinypcminfo \
    tinyplay \
    update_engine_client

PRODUCT_HOST_PACKAGES += \
    tinyplay

# Enable configurable audio policy
PRODUCT_PACKAGES += \
    libaudiopolicyengineconfigurable \
    libpolicy-subsystem

# Include all zygote init scripts. "ro.zygote" will select one of them.
PRODUCT_PACKAGES += \
    init.zygote32.rc \
    init.zygote64.rc \
    init.zygote64_32.rc

# Enable dynamic partition size
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_NAME := atv_generic_system
PRODUCT_BRAND := generic

# Define /system partition-specific product properties to identify that /system
# partition is atv_generic_system.
PRODUCT_SYSTEM_NAME := atv_generic
PRODUCT_SYSTEM_BRAND := Android
PRODUCT_SYSTEM_MANUFACTURER := Android
PRODUCT_SYSTEM_MODEL := atv_generic
PRODUCT_SYSTEM_DEVICE := generic

_base_mk_whitelist :=

_my_whitelist := $(_base_mk_whitelist)

# For mainline, system.img should be mounted at /, so we include ROOT here.
_my_paths := \
  $(TARGET_COPY_OUT_ROOT)/ \
  $(TARGET_COPY_OUT_SYSTEM)/ \

$(call require-artifacts-in-path, $(_my_paths), $(_my_whitelist))

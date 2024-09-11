#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        vendor/etc/init/init.batterysecret.rc)
            sed -i "/seclabel u:r:batterysecret:s0/d" "${2}"
            ;;
        vendor/lib/hw/audio.primary.umi.so)
            ${PATCHELF} --set-soname "audio.primary.umi.so" "${2}"
            sed -i "s|/vendor/lib/liba2dpoffload\.so|liba2dpoffload_umi\.so\x00\x00\x00\x00\x00\x00\x00\x00" "${2}"
            ;;
        vendor/lib/liba2dpoffload_umi.so)
            ${PATCHELF} --set-soname "liba2dpoffload_umi.so" "${2}"
            ;;
        vendor/lib64/camera/components/com.mi.node.watermark.so)
            "${PATCHELF}" --add-needed "libpiex_shim.so" "${2}"
            ;;
        vendor/lib64/hw/fingerprint.fpc_fod.default.so)
            ${PATCHELF} --set-soname "fingerprint.fpc_fod.default.so" "${2}"
            ;;
        vendor/lib64/hw/fingerprint.goodix_fod.default.so)
            ${PATCHELF} --set-soname "fingerprint.goodix_fod.default.so" "${2}"
            ;;
        vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so)
            "${SIGSCAN}" -p "9A 0A 00 94" -P "1F 20 03 D5" -f "${2}"
            ;;
    esac
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=umi
export DEVICE_COMMON=sm8250-common
export VENDOR=xiaomi

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"

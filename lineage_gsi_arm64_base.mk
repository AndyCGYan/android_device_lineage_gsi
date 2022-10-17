$(call inherit-product, vendor/lineage/build/target/product/lineage_gsi_arm64.mk)

$(call inherit-product, device/lineage/gsi/device.mk)
$(call inherit-product, vendor/hardware_overlay/overlay.mk)

PRODUCT_DEVICE := lineage_gsi_arm64
PRODUCT_MODEL := LineageOS GSI on ARM64

PRODUCT_CHARACTERISTICS := device

PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS :=

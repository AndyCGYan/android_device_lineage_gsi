DEVICE_PATH := device/lineage/gsi

# Overlays
PRODUCT_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay \
    $(DEVICE_PATH)/overlay-lineage

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

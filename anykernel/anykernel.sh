### AnyKernel3 Ramdisk Mod Script
## Redmi Note 12 4G (tapas / topaz, SM6225 "khaje")
## Stage 0: replaces the boot image kernel only; stock vendor_dlkm modules stay in place.

properties() { '
kernel.string=tapas Stage-0 kernel (5.15 GKI base)
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=1
device.name1=tapas
device.name2=topaz
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; }

boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
}

BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# shellcheck disable=SC1091
. tools/ak3-core.sh;

# boot.img on this device is header v4 with an empty ramdisk (the real ramdisk
# lives in init_boot/vendor_boot), so skip ramdisk unpack/repack entirely.
split_boot;
flash_boot;

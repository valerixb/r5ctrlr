FILESEXTRAPATHS:prepend:r5ctrlr-zcu102 := "${THISDIR}/files/zcu102:"
FILESEXTRAPATHS:prepend:r5ctrlr-xu1st1 := "${THISDIR}/files/xu1st1:"

SRC_URI:append:r5ctrlr-xu1st1 = " file://0008-new2025p2-Enclustra-MAC-address-readout-from-EEPROM.patch"
SRC_URI:append:r5ctrlr-xu1st1 = " file://0010-new2025p2-Enclustra-Zynqmp-Board-Patch.patch"
SRC_URI:append:r5ctrlr-xu1st1 = " file://0050-new2025p2-update-ksz9131-driver.patch"
SRC_URI:append:r5ctrlr-xu1st1 = " file://sf_default_speed_50mhz.cfg"

SRC_URI:append = " file://usr-u-boot.cfg"
SRC_URI:append:r5ctrlr-xu1st1 = " file://enclustra-u-boot.cfg"

SDBOOTDEV:r5ctrlr-xu1st1 = "1"
# KERNEL_ROOT_SD = "root=/dev/\${bootdev}${PARTNUM} rw rootwait"


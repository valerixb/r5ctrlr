FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://0008-new2025p2-Enclustra-MAC-address-readout-from-EEPROM.patch"
SRC_URI:append = " file://0010-new2025p2-Enclustra-Zynqmp-Board-Patch.patch"
SRC_URI:append = " file://0050-new2025p2-update-ksz9131-driver.patch"
SRC_URI:append = " file://sf_default_speed_50mhz.cfg"

SRC_URI:append = " file://usr-u-boot.cfg"
SRC_URI:append = " file://enclustra-u-boot.cfg"

SDBOOTDEV = "1"
# KERNEL_ROOT_SD = "root=/dev/\${bootdev}${PARTNUM} rw rootwait"


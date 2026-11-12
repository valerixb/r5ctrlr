FILESEXTRAPATHS:prepend:r5ctrlr-zcu102 := "${THISDIR}/${PN}/zcu102:"
FILESEXTRAPATHS:prepend:r5ctrlr-xu1st1 := "${THISDIR}/${PN}/xu1st1:"

SRC_URI:append = " file://usr.cfg"
SRC_URI:append:r5ctrlr-xu1st1 = " file://enclustra-kernel.cfg"
KERNEL_FEATURES:append = " usr.cfg"
KERNEL_FEATURES:append:r5ctrlr-xu1st1 = " enclustra-kernel.cfg"

ENCLUSTRA_BOOTMODE := "sd"

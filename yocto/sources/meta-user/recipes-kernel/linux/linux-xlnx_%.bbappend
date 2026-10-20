FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://usr.cfg"
SRC_URI:append = " file://enclustra-kernel.cfg"
KERNEL_FEATURES:append = " usr.cfg"
KERNEL_FEATURES:append = " enclustra-kernel.cfg"

ENCLUSTRA_BOOTMODE := "sd"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}/zynqmp/${ENCLUSTRA_BOOTMODE}:"

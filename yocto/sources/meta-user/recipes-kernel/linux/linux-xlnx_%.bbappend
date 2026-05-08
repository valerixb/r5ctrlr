FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bsp.cfg"
KERNEL_FEATURES:append = " bsp.cfg"
SRC_URI += "file://user_2026-03-09-08-51-00.cfg \
            file://user_2026-03-10-07-55-00.cfg \
            file://usr.cfg \
            "


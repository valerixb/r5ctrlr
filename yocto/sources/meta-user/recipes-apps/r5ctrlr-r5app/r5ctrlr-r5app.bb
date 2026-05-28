#
# This recipe copies the r5 elf to the deploy folder
#

SUMMARY = "R5 controller real time application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://R5app.elf"

S = "${WORKDIR}"

#FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit deploy

do_deploy() {
    # Install the app into the deploy directory
    install -d ${DEPLOYDIR}
    install -m 0755 ${THISDIR}/files/R5app.elf ${DEPLOYDIR}/R5app.elf
}

# Ensure deploy runs
addtask deploy before do_build

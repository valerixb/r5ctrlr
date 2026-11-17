FILESEXTRAPATHS:prepend:r5ctrlr-zcu102 := "${THISDIR}/files/zcu102:"
FILESEXTRAPATHS:prepend:r5ctrlr-xu1st1 := "${THISDIR}/files/xu1st1:"

SRC_URI:append = " file://system-user.dtsi"
# For Enclustra board I don't need include enclustra_xu1st1.dtsi, as 
# it is used by sdtgen when generating the system device tree from the
# exported hardware xsa file, so it's already included there

require ${@'device-tree-sdt.inc' if d.getVar('SYSTEM_DTFILE') != '' else ''}

#do_compile:prepend(){
#    bb.warn("uasciuari "+ d.getVar('BPN'))
#}

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://system-user.dtsi"
# I don't include enclustra_xu1st1.dtsi, as it is used by sdtgen when generating
# the system device tree from the exported hardware xsa file, so it's already
# included there

require ${@'device-tree-sdt.inc' if d.getVar('SYSTEM_DTFILE') != '' else ''}

#do_compile:prepend(){
#    bb.warn("uasciuari "+ d.getVar('BPN'))
#}

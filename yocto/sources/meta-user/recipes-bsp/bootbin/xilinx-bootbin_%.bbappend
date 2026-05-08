#
# This recipe adds the r5 elf to boot.bin
#

# Add dependency to your custom app
DEPENDS += "r5ctrlr-r5app"

# Append your binary to the boot image configuration
BIF_PARTITION_ATTR  = "fsbl pmufw bitstream arm-trusted-firmware device-tree u-boot-xlnx r5ctrlr-r5app"
BIF_PARTITION_IMAGE[r5ctrlr-r5app] = "${DEPLOY_DIR_IMAGE}/R5app.elf"
BIF_PARTITION_ATTR[r5ctrlr-r5app]="destination_cpu=r5-0"

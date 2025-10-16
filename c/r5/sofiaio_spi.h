//
// R5 integrated controller 
// ZCU102 + ADI CN0585/CN0584
//
// IRQs from PL and 
// interproc communications with A53/linux
//
//////////////////////////////////////////
//
// this is the setup of the SPI version of Sofia's I/O card
// It's interfaced via a Xilinx standard AXI (quad) SPI IP
// and a Xilinx standard AXI GPIO IP in PL
//

#ifndef SOFIAIO_SPI_H_
#define SOFIAIO_SPI_H_

#include "xparameters.h"
#include "xgpio.h"
#include "xspi.h"
#include "xspi_l.h"
#include "xil_printf.h"
#include "common.h"

// AXI GPIO has base address 0x80080000, which is XPAR_SOFIAIO_GPIO_BASEADDR in xparameters.h
// AXI SPI has base address 0x80090000, which is XPAR_SOFIAIO_SPI_BASEADDR in xparameters.h
#define SOFIAIO_GPIO_BADDR     XPAR_SOFIAIO_GPIO_BASEADDR
#define SOFIAIO_XSPI_BADDR     XPAR_SOFIAIO_SPI_BASEADDR
// AXI GPIO ID used for SofiaIO_SPI is 1, even if it's not defined in xparameters.h
//#define SOFIAIO_GPIO_DEVICE_ID        1

// ##########  types  #######################

// ##########  extern globals  ################

// ##########  protos  ########################
int SofiaIO_SPI_Init(void);



#endif

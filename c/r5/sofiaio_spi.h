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
#define SOFIAIO_SPI_GPIO_BADDR     XPAR_SOFIAIO_GPIO_BASEADDR
#define SOFIAIO_SPI_XSPI_BADDR     XPAR_SOFIAIO_SPI_BASEADDR
// GPIO defs
#define SOFIAIO_SPI_GPIO_OUT_CH         1
#define SOFIAIO_SPI_GPIO_IN_CH          2
// GPIO CH1 bits
#define SOFIAIO_SPI_GPIO_ADDRMASK       0x07
#define SOFIAIO_SPI_GPIO_DAC_RESETN     0x08
#define SOFIAIO_SPI_GPIO_ADC_RESET      0x10
// device address on card (decoded by the '138)
#define SOFIAIO_SPI_DAC1_ADDR           0x00
#define SOFIAIO_SPI_DAC2_ADDR           0x01
#define SOFIAIO_SPI_ADC_ADDR            0x02
#define SOFIAIO_SPI_DIGOUT16BIT_ADDR    0x03
#define SOFIAIO_SPI_DIGIN16BIT_ADDR     0x05

// ADC AD7606C-16 defs
#define SOFIAIO_SPI_AD7606_HIGHBW_REG   0x07
#define SOFIAIO_SPI_AD7606_SPIMODE_REG  0x02

#define SOFIAIO_SPI_RESET_WAIT          10000UL


// ##########  types  #######################

// ##########  extern globals  ################

// ##########  protos  ########################
int SofiaIO_SPI_Init(void);
int SofiaIO_SPI_16bit_transaction(s16 *outptr, s16 *inptr);
int SofiaIO_SPI_ReadADCs(s16 *ptr);



#endif

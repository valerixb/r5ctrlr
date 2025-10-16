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

#include "sofiaio_spi.h"

// ##########  globals  #######################

static XSpi  Sofiaio_SpiInstance;
static XGpio Sofiaio_GpioInstance;


// ##########  implementation  ################

int SofiaIO_SPI_Init(void)
  {
  int status;
  XSpi_Config  *SPIconfigPtr;
  XGpio_Config *GPIOconfigPtr;
  
  // init SPI IP --------------------------------------------------------------

  SPIconfigPtr = XSpi_LookupConfig(SOFIAIO_XSPI_BADDR);

  if(SPIconfigPtr == NULL)
    {
    return XST_DEVICE_NOT_FOUND;
    }
  
  status = XSpi_CfgInitialize(&Sofiaio_SpiInstance, SPIconfigPtr, SPIconfigPtr->BaseAddress);
  if(status == XST_DEVICE_IS_STARTED)
    {
    // this is not the first reset: the SPI intf must be stopped first
    (void)XSpi_Stop(&Sofiaio_SpiInstance);
    // then we try to init again
    status = XSpi_CfgInitialize(&Sofiaio_SpiInstance, SPIconfigPtr, SPIconfigPtr->BaseAddress);
    }

  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  status = XSpi_SelfTest(&Sofiaio_SpiInstance);
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // AXI SPI options: master, manual slave select; we set CPHA=0 and CPOL=0, 
  // but that will be changed when accessing the different devices on the board;
  // the options for CPOL=1, CPHA=0 are:
  // XSP_MASTER_OPTION || XSP_MANUAL_SSELECT_OPTION || XSP_CLK_ACTIVE_LOW_OPTION
  status = XSpi_SetOptions(&Sofiaio_SpiInstance, XSP_MASTER_OPTION || XSP_MANUAL_SSELECT_OPTION);
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // we operate manual slave select mode, so deselect the slave 
  // (use 1 instead of 0 to select the only slave we have; it's bit-coded)
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 0 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // start but disable the interrupts 
  // note that IRQ disable API must be called AFTER start API
  XSpi_Start(&Sofiaio_SpiInstance);
  XSpi_IntrGlobalDisable(&Sofiaio_SpiInstance);


  // init GPIO IP -------------------------------------------------------------

  GPIOconfigPtr=XGpio_LookupConfig(XPAR_SOFIAIO_GPIO_BASEADDR);
  if(NULL==GPIOconfigPtr) 
    return XST_FAILURE;

  status=XGpio_CfgInitialize(&Sofiaio_GpioInstance, GPIOconfigPtr, GPIOconfigPtr->BaseAddress);
  if (status!=XST_SUCCESS)
    return XST_FAILURE;

  status=XGpio_SelfTest(&Sofiaio_GpioInstance);
  if(status!=XST_SUCCESS)
    return XST_FAILURE;


  return status;
  }
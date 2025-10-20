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

int SofiaIO_SPI_16bit_transaction(s16 *outptr, s16 *inptr)
  {
  int status=XST_SUCCESS;

  // assert /CS
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 1 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // send 16 bits
  status = XSpi_Transfer(&Sofiaio_SpiInstance, outptr, inptr, 2);

  // deassert /CS
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 0 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }
  
  return status;
  }


// -----------------------------------------------------------

int SofiaIO_SPI_Init(void)
  {
  int status;
  XSpi_Config  *SPIconfigPtr;
  XGpio_Config *GPIOconfigPtr;
  u8           outbuf[2];
  
  // init SPI IP --------------------------------------------------------------

  SPIconfigPtr = XSpi_LookupConfig(SOFIAIO_SPI_XSPI_BADDR);

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

  // you can use the base address to lookup the config even if the documentation talks of ID
  GPIOconfigPtr=XGpio_LookupConfig(SOFIAIO_SPI_GPIO_BADDR);
  if(NULL==GPIOconfigPtr) 
    return XST_FAILURE;

  status=XGpio_CfgInitialize(&Sofiaio_GpioInstance, GPIOconfigPtr, GPIOconfigPtr->BaseAddress);
  if (status!=XST_SUCCESS)
    return XST_FAILURE;

  status=XGpio_SelfTest(&Sofiaio_GpioInstance);
  if(status!=XST_SUCCESS)
    return XST_FAILURE;


  // hardware reset ---------------------------------------------

  // apply reset (DAC reset is negated), default device address to 0
  XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, SOFIAIO_SPI_GPIO_ADC_RESET);
  usleep(SOFIAIO_SPI_RESET_WAIT);
  // remove reset
  XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, SOFIAIO_SPI_GPIO_DAC_RESETN);

  // ADC init ---------------------------------------------
  
  // ADC is AD7606C-16; it uses 16-bit SPI transaction, but we have an 8-bit SPI in PL to be 
  // compatible with DAC and DIG I/Os; /CS assertion is manual

  // select ADC address on card (selected by the '138)
  XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, 
                      SOFIAIO_SPI_GPIO_DAC_RESETN | SOFIAIO_SPI_ADC_ADDR);

  // --- set register mode by reading any register
 
  outbuf[0]= 0x40 | SOFIAIO_SPI_AD7606_HIGHBW_REG;    // could be any other register
  outbuf[1]= 0xFF;                                    // dummy: ignored 
  status = SofiaIO_SPI_16bit_transaction(outbuf, NULL);
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }
  
  outbuf[0]= SOFIAIO_SPI_AD7606_HIGHBW_REG;           // could be any other register
  outbuf[1]= 0xFF ;                                   // dummy: ignored 
  status = SofiaIO_SPI_16bit_transaction(outbuf, NULL);
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // now ADC is in register mode

  // set high bandwidth mode (220 kHz internal filter)

  outbuf[0]= SOFIAIO_SPI_AD7606_HIGHBW_REG;
  outbuf[1]= 0xFF;
  status = SofiaIO_SPI_16bit_transaction(outbuf, NULL);
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // (optional) set single SPI mode

  outbuf[0]= SOFIAIO_SPI_AD7606_SPIMODE_REG;
  outbuf[1]= 0x00;
  status = SofiaIO_SPI_16bit_transaction(outbuf, NULL);
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // revert to ADC read mode transmitting 0 for 16 SPI SCLK cycles

  outbuf[0]= 0x00;
  outbuf[1]= 0x00;
  status = SofiaIO_SPI_16bit_transaction(outbuf, NULL);
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // now ADC is back in ADC read mode


  // DAC init ---------------------------------------------
  // TODO

  // DIG OUT init ---------------------------------------------
  // TODO

  return status;
  }


// -----------------------------------------------------------

int SofiaIO_SPI_ReadADCs(s16 *sampleptr)
  {
  u8  outbuf[2];
  int i, status=XST_SUCCESS;

  // select ADC address on card
  XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, 
                      SOFIAIO_SPI_GPIO_DAC_RESETN | SOFIAIO_SPI_ADC_ADDR);
  
  // AD7606C-16 has 8 channels, but here we use the first 4 only
  
  outbuf[0]=0;
  outbuf[1]=0;
  
  for(i=0; i<4; i++)
    {
    status = SofiaIO_SPI_16bit_transaction(outbuf, sampleptr+i);
    if(status != XST_SUCCESS)
      {
      return XST_FAILURE;
      }
    }
  
  return status;  
  }

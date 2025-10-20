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
  // don't check status, as I want to end the SPI transaction releasing /CS

  // deassert /CS
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 0 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }
  
  return status;
  }


// -----------------------------------------------------------

int SofiaIO_SPI_ADC_Init(void)
  {
  u8           outbuf[2];
  int status=XST_SUCCESS;

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
  }


// -----------------------------------------------------------

int SofiaIO_SPI_WriteDacRegister(u8 addr, u8 data)
  {
  u8  outbuf[2];
  int status=XST_SUCCESS;

  outbuf[0]=addr;
  outbuf[1]=data;

  // assert /CS
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 1 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // send 16 bits
  status = XSpi_Transfer(&Sofiaio_SpiInstance, outbuf, NULL, 2);
  // don't check status, as I want to end the SPI transaction releasing /CS

  // deassert /CS
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 0 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }
  
  return status;
  }


// -----------------------------------------------------------

int SofiaIO_SPI_WriteDacSamples(int DACindex, u16 ch0data, u16 ch1data)
  {
  u8  outbuf[4];
  int status=XST_SUCCESS;

  // select ADC address on card (selected by the '138)
  if(DACindex==0)
    XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, 
                        SOFIAIO_SPI_GPIO_DAC_RESETN | SOFIAIO_SPI_DAC1_ADDR);
  else
    XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, 
                      SOFIAIO_SPI_GPIO_DAC_RESETN | SOFIAIO_SPI_DAC2_ADDR);

  // assert /CS
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 1 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // send address
  outbuf[0]=0x4B;
  status = XSpi_Transfer(&Sofiaio_SpiInstance, outbuf, NULL, 1);
  // don't check status, as I want to end the SPI transaction releasing /CS

  // send CH1 data
  outbuf[0]=ch1data & 0x00FF;
  outbuf[1]=(ch1data>>8) & 0x00FF;
  outbuf[2]=0x00;
  status = XSpi_Transfer(&Sofiaio_SpiInstance, outbuf, NULL, 3);
  // don't check status, as I want to end the SPI transaction releasing /CS

  // send CH0 data
  outbuf[0]=ch0data & 0x00FF;
  outbuf[1]=(ch0data>>8) & 0x00FF;
  outbuf[2]=0x00;
  status = XSpi_Transfer(&Sofiaio_SpiInstance, outbuf, NULL, 3);
  // don't check status, as I want to end the SPI transaction releasing /CS

  // deassert /CS
  status = XSpi_SetSlaveSelect(&Sofiaio_SpiInstance, 0 );
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  return status;
  }


// -----------------------------------------------------------

int SofiaIO_SPI_DAC_Init(void)
  {
  u8  outbuf[2];
  int status=XST_SUCCESS;
  int DACindex;

  // DAC is ADI AD3552R; each chip has 2 DAC channels; we have two chips on board
  
  for(DACindex=0; DACindex<NUM_DACS; DACindex++)
    {
    // select ADC address on card (selected by the '138)
    if(DACindex==0)
      XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, 
                          SOFIAIO_SPI_GPIO_DAC_RESETN | SOFIAIO_SPI_DAC1_ADDR);
    else
      XGpio_DiscreteWrite(&Sofiaio_GpioInstance,SOFIAIO_SPI_GPIO_OUT_CH, 
                        SOFIAIO_SPI_GPIO_DAC_RESETN | SOFIAIO_SPI_DAC2_ADDR);
    
    // soft reset
    status=SofiaIO_SPI_WriteDacRegister(AD3552_INTERFACE_CONFIG_A, 0x91);
    if(status != XST_SUCCESS)
      {
      return XST_FAILURE;
      }

    usleep(SOFIAIO_SPI_RESET_WAIT);

    // remove reset
    status=SofiaIO_SPI_WriteDacRegister(AD3552_INTERFACE_CONFIG_A, 0x10);
    if(status != XST_SUCCESS)
      {
      return XST_FAILURE;
      }

    // set 10V fullscale
    status=SofiaIO_SPI_WriteDacRegister(AD3552_CH0_CH1_OUTPUT_RANGE, 0x44);
    if(status != XST_SUCCESS)
      {
      return XST_FAILURE;
      }
    
    // 6-byte loopback on streaming
    status=SofiaIO_SPI_WriteDacRegister(AD3552_STREAM_MODE, 0x06);
    if(status != XST_SUCCESS)
      {
      return XST_FAILURE;
      }

    // keep loopback length between transactions
    status=SofiaIO_SPI_WriteDacRegister(AD3552_TRANSFER_REGISTER, 0x84);
    if(status != XST_SUCCESS)
      {
      return XST_FAILURE;
      }

    }

  return status;
  }


// -----------------------------------------------------------

int SofiaIO_SPI_Init(void)
  {
  int status;
  XSpi_Config  *SPIconfigPtr;
  XGpio_Config *GPIOconfigPtr;
  
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
  status=SofiaIO_SPI_ADC_Init();
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // DAC init ---------------------------------------------
  status=SofiaIO_SPI_DAC_Init();
  if(status != XST_SUCCESS)
    {
    return XST_FAILURE;
    }

  // DIG OUT init ---------------------------------------------
  // TODO

  return status;
  }


// -----------------------------------------------------------

int SofiaIO_SPI_ReadADCs(s16 *sampleptr)
  {
  u8  outbuf[2];
  int i, status=XST_SUCCESS;

  // select ADC address on card (selected by the '138)
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

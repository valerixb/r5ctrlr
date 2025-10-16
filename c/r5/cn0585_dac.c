//
// R5 integrated controller 
// ZCU102 + ADI CN0585/CN0584
//
// IRQs from PL and 
// interproc communications with A53/linux
//
//////////////////////////////////////////
//
// this is the management of the two dual DACs AD3552 on ADI CN0585
// It's interfaced via our custom IP in PL
//

#include "cn0585_dac.h"

// ##########  globals  #######################

volatile u32 *CN0585_DAC_BADDR[] = {(volatile u32 *)DAC_A_BADDR, (volatile u32 *)DAC_B_BADDR};


// ##########  implementation  ################

int CN0585_WriteDacRegister(int DACindex, u32 addr, u8 data)
  {
  int errcode;

  *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT) = DAC_WRITE_TRANSACTION |
                                               DAC_ADDRESS_PHASE |
                                               DAC_1_BYTE_TRANSACTION |
                                               addr;

  *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT) = DAC_WRITE_TRANSACTION |
                                               DAC_DATA_PHASE |
                                               DAC_LAST_TRANSACTION |
                                               DAC_1_BYTE_TRANSACTION |
                                               data;
  errcode= (int)(*(CN0585_DAC_BADDR[DACindex]+DAC_STATUS_WORD) & DAC_SPI_ERRCODE_MASK);
  return errcode;
  }


// -----------------------------------------------------------

int CN0585_ReadDacRegister(int DACindex, u32 addr, u8* dataptr)
  {
  int errcode, retries;
  u32 theval;

  // READ transactions cannot go at max speed; 
  // see AD3552 datasheet page 6,
  // parameter T9= SCLK falling edge to SDO data valid = 15 ns
  // so we use a 62.5 MHz /4 clock for SPI SCLK instead of 
  // the undivided 62.5 MHz for write transactions
  *(CN0585_DAC_BADDR[DACindex]+DAC_CTRL_WORD) = SPI_CLK_DIVIDE_BY_4;

  *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT) = DAC_WRITE_TRANSACTION |
                                               DAC_ADDRESS_PHASE |
                                               DAC_1_BYTE_TRANSACTION |
                                               addr | DAC_ADDR_READ_TRANSACT;

  *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT) = DAC_READ_TRANSACTION |
                                               DAC_DATA_PHASE |
                                               DAC_LAST_TRANSACTION |
                                               DAC_1_BYTE_TRANSACTION;

  retries=MAX_READ_RETRIES;
  do
    {
    theval = *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT);
    retries--;
    }
  while(((theval & DAC_TRANSACTION_ENDED_MASK)==0) && (retries>0));
  
  errcode= (int)(*(CN0585_DAC_BADDR[DACindex]+DAC_STATUS_WORD) & DAC_SPI_ERRCODE_MASK);
  *dataptr = (u8)(theval & DAC_DATA_MASK & 0x000000FF);

  // restore the fast SPI SCLK used for regular write transactions
  *(CN0585_DAC_BADDR[DACindex]+DAC_CTRL_WORD) = SPI_CLK_NO_DIVIDER;

  return (retries>0) ? errcode : DAC_SPI_ERR_RD_TIMEOUT;
  }


// -----------------------------------------------------------


int CN0585_Init_DAC(void)
  {
  int i, status, retries;
  u32 theval, theerr;
  
  for(i=0; i<NUM_DACS; i++)
    {

    // set CLK divider=2 and perform both HW and SW reset
    *(CN0585_DAC_BADDR[i]+DAC_CTRL_WORD) = DAC_INPUT_REGISTER | SPI_CLK_NO_DIVIDER | DAC_HW_RESET | DAC_SOFT_RESET;
     
    usleep(RESET_WAIT);
     
    // remove HW reset
    *(CN0585_DAC_BADDR[i]+DAC_CTRL_WORD) = SPI_CLK_NO_DIVIDER;
    
    // soft reset
    theerr=CN0585_WriteDacRegister(i,AD3552_INTERFACE_CONFIG_A, 0x91);
    if(theerr!=DAC_SPI_NOERR) return XST_FAILURE;
    
    usleep(RESET_WAIT);
    
    // remove reset
    theerr=CN0585_WriteDacRegister(i,AD3552_INTERFACE_CONFIG_A, 0x10);
    if(theerr!=DAC_SPI_NOERR) return XST_FAILURE;
    
    // set 10V fullscale
    theerr=CN0585_WriteDacRegister(i,AD3552_CH0_CH1_OUTPUT_RANGE, 0x44);
    if(theerr!=DAC_SPI_NOERR) return XST_FAILURE;
    
    // 6-byte loopback on streaming
    theerr=CN0585_WriteDacRegister(i,AD3552_STREAM_MODE, 0x06);
    if(theerr!=DAC_SPI_NOERR) return XST_FAILURE;
    
    // keep loopback length between transactions
    theerr=CN0585_WriteDacRegister(i,AD3552_TRANSFER_REGISTER, 0x84);
    if(theerr!=DAC_SPI_NOERR) return XST_FAILURE;

    }

  return XST_SUCCESS;
  }


// -----------------------------------------------------------

int CN0585_WriteDacSamples(int DACindex, u16 ch0data, u16 ch1data)
  {
  u32 ch0val, ch1val;
  int errcode;

  // reorder bytes for proper SPI transaction
  ch0val= ((u32)(ch0data)>>8)&0x000000FF | ((u32)(ch0data)<<8)&0x0000FF00;
  ch1val= ((u32)(ch1data)>>8)&0x000000FF | ((u32)(ch1data)<<8)&0x0000FF00;

  *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT) = DAC_WRITE_TRANSACTION |
                                               DAC_ADDRESS_PHASE |
                                               DAC_1_BYTE_TRANSACTION |
                                               0x4B;

  *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT) = DAC_WRITE_TRANSACTION |
                                               DAC_DATA_PHASE |
                                               DAC_3_BYTE_TRANSACTION |
                                               ch1val;

  *(CN0585_DAC_BADDR[DACindex]+DAC_TRANSACT) = DAC_WRITE_TRANSACTION |
                                               DAC_DATA_PHASE |
                                               DAC_LAST_TRANSACTION |
                                               DAC_3_BYTE_TRANSACTION |
                                               ch0val;
  
  errcode= (int)(*(CN0585_DAC_BADDR[DACindex]+DAC_STATUS_WORD) & DAC_SPI_ERRCODE_MASK);
  return errcode;
  }


// -----------------------------------------------------------

int CN0585_UpdateDacOutput(int DACindex)
{
int theerr;

theerr=CN0585_WriteDacRegister(DACindex,AD3552_SW_LDAC_24B, 0x03);
return theerr;
}

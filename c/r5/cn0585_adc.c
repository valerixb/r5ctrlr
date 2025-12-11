//
// R5 integrated controller 
// ZCU102 + ADI CN0585/CN0584
//
// IRQs from PL and 
// interproc communications with A53/linux
//
//////////////////////////////////////////
//
// this is the management of the four ADCs ADAQ23876 on ADI CN0585
// It's interfaced via our custom IP in PL
//

#include "cn0585_adc.h"

// ##########  globals  #######################

// ##########  implementation  ################

int CN0585_Init_ADC(void)
  {
  int i, status;
  *((volatile u32 *)XPAR_QUAD_ADAQ23876_0_BASEADDR+ADC_CTRL_WORD) = ADC_TACQ | ADC_SCLK_DIV;

  return XST_SUCCESS;
  }


// -----------------------------------------------------------

// s16 means signed int 16
void CN0585_ReadADCs(s16 *ptr)
  {
  u32 x;
  x=*((volatile u32 *)XPAR_QUAD_ADAQ23876_0_BASEADDR+ADC_chan_B_A);
  *ptr     =      x  & 0x0000FFFF;
  *(ptr+1) = (x>>16) & 0x0000FFFF;
  x=*((volatile u32 *)XPAR_QUAD_ADAQ23876_0_BASEADDR+ADC_chan_D_C);
  *(ptr+2) =      x  & 0x0000FFFF;
  *(ptr+3) = (x>>16) & 0x0000FFFF;
  }

// -----------------------------------------------------------



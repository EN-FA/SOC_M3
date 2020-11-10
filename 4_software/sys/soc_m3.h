#ifndef __SOC_M3__
#define __SOC_M3__

#pragma anon_unions


#define	REG32(x)	*(volatile unsigned int *) (x)

#define SystemCoreClock		(30000000UL)

#define apb_base				(0x40000000UL)

#define apb_led					(0x40001000+0x0c)

#define uart_base				(apb_base)



#endif
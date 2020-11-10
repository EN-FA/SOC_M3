#include <stdio.h>
#include "sys.h"
#include "soc_m3.h"
#include "uart.h"



void SystemInit(void){
		uart_init (UART, (SystemCoreClock / 115200), 1,1,0,0,0,0 );
}
	
	


int main(){	
	REG32(apb_led)=0xf;
	delay_us(1);
	REG32(apb_led)=0x0;
	delay_us(1);
	REG32(apb_led)=0xf;
	delay_us(1);
	REG32(apb_led)=0x0;
	delay_us(3);
	while(1){
		REG32(apb_led)=0x1;
		delay_ms(1);
		REG32(apb_led)=0x2;
		delay_ms(1);
		REG32(apb_led)=0x4;
		delay_ms(1);
		REG32(apb_led)=0x8;
		delay_ms(1);
		printf("hello M3!!\n");
	}

	return 0;
}


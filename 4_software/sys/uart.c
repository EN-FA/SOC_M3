#include "soc_m3.h"
#include "sys.h"
#include "uart.h"
#include "string.h"
#include "stdio.h"

unsigned int uart_init(uart_typedef *uart, unsigned int divider, unsigned int tx_en, unsigned int rx_en, unsigned int tx_irq_en, 
	unsigned int rx_irq_en, unsigned int tx_ovrirq_en, unsigned int rx_ovrirq_en){
													
		unsigned int new_ctrl=0;
		if (tx_en!=0)        new_ctrl |=  UART_CTRL_TXEN_Msk;
    if (rx_en!=0)        new_ctrl |=  UART_CTRL_RXEN_Msk;
    if (tx_irq_en!=0)    new_ctrl |=  UART_CTRL_TXIRQEN_Msk;
    if (rx_irq_en!=0)    new_ctrl |=  UART_CTRL_RXIRQEN_Msk;
    if (tx_ovrirq_en!=0) new_ctrl |=  UART_CTRL_TXORIRQEN_Msk;
    if (rx_ovrirq_en!=0) new_ctrl |=  UART_CTRL_RXORIRQEN_Msk;
		
		uart->ctrl = 0;
		uart->bauddiv = divider;
		uart->ctrl = new_ctrl;
		
		if((uart->state & (UART_STATE_RXOR_Msk |  UART_STATE_TXOR_Msk)))
			return 1;
		else
			return 0;
}
	

unsigned int uart_gettxbufferfull(uart_typedef *uart){
		return (( uart->state &  UART_STATE_TXBF_Msk)>>  UART_STATE_TXBF_Pos);
}


void uart_sendchar(uart_typedef * uart, char txchar){
		while( 1 ){
      if(!(uart->state &  UART_STATE_TXBF_Msk)) break;
    };
    uart->data = (unsigned int)txchar;
}
 
 
char uart_receivechar(uart_typedef * uart){
		while(!(uart->state & UART_STATE_RXBF_Msk));
		return (char)(uart->data);
}

unsigned int uart_getoverrunstatus(uart_typedef *uart){
	  return((uart->state & (UART_STATE_RXOR_Msk | UART_STATE_TXOR_Msk)) >> UART_STATE_TXOR_Pos);
}
 
 
unsigned int uart_getbauddivider(uart_typedef *uart){

		return uart->bauddiv;
}
 
unsigned int uart_gettxirqstatus(uart_typedef *uart){
		return ((uart->intstatus & UART_CTRL_TXIRQ_Msk) >> UART_CTRL_TXIRQ_Pos);

}
 
void uart_cleartxirq(uart_typedef *uart){
    uart->intclear =  UART_CTRL_TXIRQ_Msk;
}

void uart_clearrxirq(uart_typedef *uart){
    uart->intclear =  UART_CTRL_RXIRQ_Msk;
}

void uart_sendstring(char *string){
    unsigned int length,i;
    length = strlen(string);
    for(i = 0;i < length;i++) {
       uart_sendchar(UART,string[i]);
    }
}





/****************printf重新定向*****************************/
struct __FILE { int handle; /* Add whatever you need here */ };
FILE __stdout;
FILE __stdin;


int fputc(int ch, FILE *f) {
  if(ch == '\n') uart_sendchar(UART,'\r');
  uart_sendchar(UART,ch);
  return (ch);
}

int fgetc(FILE *f) {
  char buf;
  buf = uart_receivechar(UART);
  uart_sendchar(UART,buf);
  if(buf == '\r') buf = '\n';
  return (buf);
}























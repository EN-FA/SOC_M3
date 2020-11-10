#include <stdio.h>
#include "sys.h"

/*
#ifdef __GNUC__
		#define PUTCHAR_PROTOTYPE int __io_putcahr(int ch)
#else
		#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE* f)
#endif


#ifdef __cplusplus
		extern "C" {
#endif
		PUTCHAR_PROTOTYPE {
				
		
		}

#ifdef __cplusplus
	}		
#endif
*/

void delay_ms(int x){
	int a,b,i;
	for(i=x;i>0;i--){
		for(a=9999;a>0;a--){
			for(b=99;b>0;b--);
		}
	}
}

void delay_us(int x){
	int a,b,i;
	for(i=x;i>0;i--){
		for(a=999;a>0;a--){
			for(b=999;b>0;b--);
		}
	}
}
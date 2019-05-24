//#include <p18F4550.h> Libreria antigua, cambiado hacia xc.h
#include <xc.h>
#include "ADC.h"


void ADC_CONFIG(char canal)
{
	TRISA = 0xFF;
	TRISE = 0xFF;
	TRISB = 0x0F;
	switch(canal)
	{
		case 0:
			ADCON1=0x0E;
			ADCON0=canal<<2;
		break;
		case 1:
			ADCON1=0x0D;
			ADCON0=canal<<2;
		break;
		case 2:
			ADCON1=0x0C;
			ADCON0=canal<<2;
		break;
		case 3:
			ADCON1=0x0B;
			ADCON0=canal<<2;
		break;
		case 4:
			ADCON1=0x0A;
			ADCON0=canal<<2;
		break;
		case 5:
			ADCON1=0x09;
			ADCON0=canal<<2;
		break;
		case 6:
			ADCON1=0x08;
			ADCON0=canal<<2;
		break;
		case 7:	
			ADCON1=0x07;
			ADCON0=canal<<2;
		break;
		case 8:
			ADCON1=0x06;
			ADCON0=canal<<2;
		break;
		case 9:
			ADCON1=0x05;
			ADCON0=canal<<2;
		break;
		case 10:
			ADCON1=0x04;
			ADCON0=canal<<2;
		break;
		case 11:
			ADCON1=0x03;
			ADCON0=canal<<2;
		break;	
		case 12:
			ADCON1=0x02;
			ADCON0=canal<<2;
		break;
	}
	ADCON2 = 0x91; 	//4TAD, FOSC/64, justificación a la derecha
	ADCON0bits.ADON = 1;
}
int  ADC_CONVERTIR(void)
{
	int num;
	ADCON0bits.GO = 1;
	while(ADCON0bits.GO);
	num = 0x03 & ADRESH;
	num<<= 8;
	num +=ADRESL;
	return(num);
}

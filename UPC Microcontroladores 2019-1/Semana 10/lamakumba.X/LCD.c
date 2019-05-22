//#include <p18F4550.h>
#include <xc.h>
#include "LCD.h"
//#include <delays.h>

void POS_CURSOR(unsigned char fila,unsigned char columna)
{
	if(fila == 1)
	{
		ENVIA_LCD_CMD(0x80+columna);
	}
	else if(fila == 2)
	{
		ENVIA_LCD_CMD(0xC0+columna);
	}
}

void BLINK_CURSOR(unsigned char val)
{
	if(val == OFF) ENVIA_LCD_CMD(0x0E);
	if(val == ON ) ENVIA_LCD_CMD(0x0F);
}

void DISPLAY_ONOFF(unsigned char estado)
{
	if(estado == ON)  ENVIA_LCD_CMD(0x0F);
	if(estado == OFF) ENVIA_LCD_CMD(0x08);
}

void CURSOR_HOME(void)
{
	ENVIA_LCD_CMD(0x02);
}

void CURSOR_ONOFF(unsigned char estado)
{	
	if(estado == ON)	ENVIA_LCD_CMD(0x0E);
	if(estado == OFF)	ENVIA_LCD_CMD(0x0C);
}

void ESCRIBE_MENSAJE(const char *cadena,unsigned char tam)
{
	unsigned char i = 0;
	for(i = 0; i<tam; i++)
	{
		ENVIA_CHAR(cadena[i]);
	}
}

void ENVIA_CHAR(unsigned char dato)
{
	unsigned char aux;
	RS = 1;
	LEER_LCD();
	TRISD = 0x00;
//        _delay(1200);
//	Delay100TCYx(12);	//Retardo de 100us
    __delay_us(100);
	RW = 0;
	E = 0;
	RS = 1;
	aux = dato & 0xF0;
	ENVIA_NIBBLE(aux);
	aux = dato << 4;
	ENVIA_NIBBLE(aux);	
}

void BORRAR_LCD(void)
{
	ENVIA_LCD_CMD(0x01);
}

void LCD_CONFIG(void)
{
	RS = 0;
	RW = 0;
	ENVIA_NIBBLE(0x30);
//        _delay(24000);
//        _delay(24000);
//	Delay1KTCYx(24);	//Retardo de 2 mseg
    __delay_ms(2);
//	Delay1KTCYx(24);
	ENVIA_NIBBLE(0x30);
//	Delay100TCYx(12);   //retardo de 100useg
	//_delay(1200);
    __delay_us(100);
    ENVIA_NIBBLE(0x30);
	ENVIA_NIBBLE(0x20);
	ENVIA_LCD_CMD(0x01);
	ENVIA_LCD_CMD(0x28);
	ENVIA_LCD_CMD(0x0F);
	ENVIA_LCD_CMD(0x06);
	ENVIA_LCD_CMD(0x01);
}

void ENVIA_NIBBLE(unsigned char dato)
{
	LATD &= 0x0F;
	dato &= 0xF0;
	LATD|= dato;
	E = 1;
//	Delay100TCYx(12);
    //    _delay(1200);
    __delay_us(100);        
	E = 0;
}

void ENVIA_LCD_CMD(unsigned char dato)
{
	unsigned char aux;
	RS = 0;
	LEER_LCD();
	TRISD = 0b00000000;
//	Delay100TCYx(12);	//Retardo de 100us
        _delay(1200);
    __delay_us(100);        
    RW = 0;
	E = 0;
	RS = 0;
	aux = dato & 0xF0;
	ENVIA_NIBBLE(aux);
	aux = dato<<4;
	ENVIA_NIBBLE(aux);
}

void LEER_LCD(void)
{
	unsigned char aux;	
	TRISD = 0xF8;
	RS = 0;
	RW = 1;
	E = 1;
//        _delay(1200);
    __delay_us(100);
    //	Delay100TCYx(12);
	aux = PORTD;
	E = 0;
    __delay_us(100);
//        _delay(1200);
//	Delay100TCYx(12);
	E = 1;
//        _delay(1200);
    __delay_us(100);    
//	Delay100TCYx(12);
	E = 0;
	aux = aux & 0x80;
	while(aux == 0x80)
        {
            E = 1;
//            _delay(1200);
    __delay_us(100);
    aux = PORTD;
            E = 0;
//            _delay(1200);
    __delay_us(100);            
            E = 1;
//            _delay(1200);
    __delay_us(100);            
            E = 0;
            aux = aux & 0x80;
	}
}

void GENERACARACTER(const unsigned char *vector,unsigned char pos)
{
	unsigned char i;
	ENVIA_LCD_CMD(0x40+8*pos);//Dirección de la CGRAM +
	for(i=0;i<8;i++)			 //offset de posición de caracter	
	{
		ENVIA_CHAR(vector[i]);
	}
	ENVIA_LCD_CMD(0x80);	//Dirección de la DDRAM
}

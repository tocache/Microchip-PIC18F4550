#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char milanesa = 174;
unsigned char d_centena = 0;
unsigned char d_decena = 0;
unsigned char d_unidad = 0;

void configuro(void){
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(20);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void digit_converter(unsigned char numero){
    d_centena = numero / 100;
    d_decena = (numero % 100) / 10;
    d_unidad = numero % 10;
}

void main(void) {
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Hola UPC Monterr",16);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Milanesa: ",10);
        digit_converter(milanesa);
        ENVIA_CHAR(d_centena + 0x30);
        ENVIA_CHAR(d_decena + 0x30);
        ENVIA_CHAR(d_unidad + 0x30);
    }
}

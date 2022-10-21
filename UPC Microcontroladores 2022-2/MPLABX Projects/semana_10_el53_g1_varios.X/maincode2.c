#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char x = 0;
unsigned char y = 0;
unsigned char adc_res = 0;
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;

void configuro(void){
    ADCON2 = 0x24;
    ADCON1 = 0x1B;
    ADCON0 = 0x01;
}

void arranca_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(23);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte_digitos(unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    arranca_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Termotester UPC", 15);
    while(1){
        ADCON0bits.GO_DONE = 1;
        while(ADCON0bits.GO_DONE);
        adc_res = (ADRESH >> 1) & 0x7F;
        convierte_digitos(adc_res);
        POS_CURSOR(2,0);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(0xDF);
        ESCRIBE_MENSAJE("C",1);
    }
}

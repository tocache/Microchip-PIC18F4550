#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;
unsigned char res_ad = 0;

void configuro(void){
    ADCON2 = 0x24;
    ADCON1 = 0x1B;
    ADCON0 = 0x01;
}

void arranque_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(17);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void digit_converter (unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    arranque_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Termometro UPC",14);
    while(1){
        ADCON0bits.GO_DONE = 1;
        while(ADCON0bits.GO_DONE == 1);
        res_ad = ((ADRESH >> 1) & 0x7F);
        digit_converter(res_ad);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("LM35: ", 6);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR(0xDF);
        ENVIA_CHAR('C');
        __delay_ms(300);
    }
}

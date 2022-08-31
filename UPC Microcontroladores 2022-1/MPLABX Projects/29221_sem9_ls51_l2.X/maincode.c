#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISCbits.RC0 = 0;      //RC0 es salida
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void titileo_RC0(void){
    LATCbits.LC0 = 1;
    __delay_ms(200);
    LATCbits.LC0 = 0;
    __delay_ms(200);
}

void main(void) {
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1, 0);
        ESCRIBE_MENSAJE("Ing. Electronica",16);        
        POS_CURSOR(2, 3);
        ESCRIBE_MENSAJE("Hola UPC",8);
        titileo_RC0();
    }
}

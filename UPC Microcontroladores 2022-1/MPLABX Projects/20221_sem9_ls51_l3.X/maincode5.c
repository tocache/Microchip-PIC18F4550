#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL


void configuro(void){
    
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}


void main(void) {
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1, 0);
        ESCRIBE_MENSAJE("Ing. Electronica",16);
        POS_CURSOR(2, 0);
        ESCRIBE_MENSAJE("Microcontrolador",16);
        __delay_ms(1000);
        POS_CURSOR(2, 0);
        ESCRIBE_MENSAJE("Ing. Electronica",16);
        POS_CURSOR(1, 0);
        ESCRIBE_MENSAJE("Microcontrolador",16);
        __delay_ms(1000);
    }
}

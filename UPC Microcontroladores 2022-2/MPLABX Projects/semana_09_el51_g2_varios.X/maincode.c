#include <xc.h>
#include "cabacera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){};

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
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Hola UPCino", 11);
    }
    
}

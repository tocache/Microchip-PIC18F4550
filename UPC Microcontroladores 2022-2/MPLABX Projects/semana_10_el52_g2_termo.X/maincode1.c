#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 32000000UL

void configuro(void){
    
}

void arranque_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(22);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    arranque_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Termoneitor UPC",15);
    while(1);
}


#include <xc.h>
#include "cabecera.inc"

#define _XTAL_FREQ 4000000UL

void configuro(void){
    TRISD = 0xFE;
}

void main(void) {
    configuro();
    while(1){
        PORTD = 0x01;
        __delay_ms(100);
        PORTD = 0x00;
        __delay_ms(100);        
    }
    return;
}

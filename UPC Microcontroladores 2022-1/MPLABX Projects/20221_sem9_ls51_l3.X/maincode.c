#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISD = 0x80;       //RD0:RD6 son salidas
}

void main(void) {
    configuro();
    while(1){
        LATD = 0x76;
        __delay_ms(500);
        LATD = 0x3F;
        __delay_ms(500);
        LATD = 0x38;
        __delay_ms(500);
        LATD = 0x77;
        __delay_ms(500);
        LATD = 0x00;
        __delay_ms(500);
        LATD = 0x3E;
        __delay_ms(500);
        LATD = 0x73;
        __delay_ms(500);
        LATD = 0x39;
        __delay_ms(500);
        LATD = 0x00;
        __delay_ms(500);
    }
}

#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISE = 0xF8;
}

void main(void) {
    configuro();
    while(1){
        LATE = 0x05;
        __delay_ms(200);
        LATE = 0x02;
        __delay_ms(200);
    }
}

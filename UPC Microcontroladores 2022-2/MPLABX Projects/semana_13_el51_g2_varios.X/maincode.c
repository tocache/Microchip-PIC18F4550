#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

void configuro(void){
    OSCCON = 0x70;  //reloj a 8MHz
    ADCON1 = 0x0F;  //ANx como digitales
    TRISE = 0xF8;   //RE2:RE0 como salidas
}

void main(void) {
    configuro();
    while(1){
        LATE = 0x07;
        __delay_ms(200);
        LATE = 0x00;
        __delay_ms(200);
    }
}

#include "cabecera.h"
#define _XTAL_FREQ 4000000UL

void configuro(void){
    OSCCONbits.IRCF2 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF0 = 0;   //INTOSC a 4MHz
    TRISDbits.RD0 = 0;  //RD0 como salida
}

void main(void) {
    configuro();
    while(1){
        LATDbits.LD0 = 1;
        __delay_ms(100);
        LATDbits.LD0 = 0;
        __delay_ms(100);
        LATDbits.LD0 = 1;
        __delay_ms(100);
        LATDbits.LD0 = 0;
        __delay_ms(1200);
    }
}

#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISCbits.RC0 = 0;     //RCO como salida
}

void main(void) {
    configuro();        /*llamada a la funcion configuro*/
    while(1){
        LATCbits.LC0 = 1;
        __delay_ms(100);
        LATCbits.LC0 = 0;
        __delay_ms(100);
    }
}

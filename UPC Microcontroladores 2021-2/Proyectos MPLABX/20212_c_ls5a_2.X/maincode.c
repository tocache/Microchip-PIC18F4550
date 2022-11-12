#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo 48MHz

void configuracion(void){
    TRISCbits.RC0 = 0;  //RC0 como salida
}

void main(void) {
    configuracion();
    while(1){
        LATCbits.LC0 = 1;
        __delay_ms(100);
        LATCbits.LC0 = 0;
        __delay_ms(100);
        LATCbits.LC0 = 1;
        __delay_ms(100);
        LATCbits.LC0 = 0;
        __delay_ms(100);
        LATCbits.LC0 = 1;
        __delay_ms(100);
        LATCbits.LC0 = 0;
        __delay_ms(1000);
    }
}

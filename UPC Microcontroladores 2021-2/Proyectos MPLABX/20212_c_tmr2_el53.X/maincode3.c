#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    PR2 = 155;
    CCPR1L = 31;
    TRISCbits.RC2 = 0;
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

void main(void) {
    configuracion();
    while(1){
        if (PORTDbits.RD0 == 1){
            CCPR1L = 116;
        }
        else{
            CCPR1L = 31;
        }
    }
}

#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    ADCON1 = 0x0F;      //Puertos E/S como digitales
    TRISEbits.RE0 = 0;  //RE0 como salida
}

void main(void) {
    configuracion();
    while(1){
        LATEbits.LE0 = 1;
        __delay_us(1500);
        LATEbits.LE0 = 0;
        __delay_us(18500);
    }
}

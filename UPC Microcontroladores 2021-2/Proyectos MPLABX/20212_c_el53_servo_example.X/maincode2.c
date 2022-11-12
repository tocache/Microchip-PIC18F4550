#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    ADCON1 = 0x0F;      //Todos los I/O como digitales
    TRISEbits.RE0 = 0;   //RE0 como salida
}

void main(void) {
    configuracion();
    while(1){
        if(PORTBbits.RB0 == 1){
            LATEbits.LE0 = 1;
            __delay_us(2000);
            LATEbits.LE0 = 0;
            __delay_us(18000);
        }
        else{
            LATEbits.LE0 = 1;
            __delay_us(1000);
            LATEbits.LE0 = 0;
            __delay_us(19000);
        }
    }
}


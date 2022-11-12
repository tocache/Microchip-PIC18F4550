#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    //OSCCONbits.IRCF2 = 1;
    //OSCCONbits.IRCF1 = 1;
    //OSCCONbits.IRCF0 = 1;   //FOSC = 8MHz
    ADCON1= 0x0F;       //Todos los puertos en digitales
    TRISEbits.RE0 = 0;  //RE0 como salida
}

void main(void) {
    configuracion();
    while(1){
        LATEbits.LE0 = 1;
        __delay_ms(100);
        LATEbits.LE0 = 0;
        __delay_ms(100);
    }
}

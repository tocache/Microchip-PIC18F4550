#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    ADCON1 = 0x0F;      //Todos los I/O como digitales
    TRISEbits.RE0 = 0;   //RE0 como salida
}

void var_delay(unsigned int tiempo){
    unsigned int x;
    for(x=0;x<tiempo;x++){
        __delay_us(1);
    }
}

void main(void) {
    configuracion();
    while(1){
        if(PORTBbits.RB0 == 1){
            LATEbits.LE0 = 1;
            var_delay(2000);
            LATEbits.LE0 = 0;
            var_delay(18000);
        }
        else{
            LATEbits.LE0 = 1;
            var_delay(1000);
            LATEbits.LE0 = 0;
            var_delay(19000);
        }
    }
}


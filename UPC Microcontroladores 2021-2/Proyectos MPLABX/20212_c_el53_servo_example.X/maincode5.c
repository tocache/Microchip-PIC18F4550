#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    ADCON1 = 0x0F;      //Todos los I/O como digitales
    TRISEbits.RE0 = 0;  //RE0 como salida
    T0CON = 0xC6;       //TMR0 ON, PSC 1:128, FOSC/4
}

void main(void) {
    configuracion();
    while(1){
        unsigned int x = 0;
        for(x=68;x<163;x++){
            LATEbits.LE0 = 1;
            TMR0L = 256 - x;
            while(INTCONbits.TMR0IF == 0);
            LATEbits.LE0 = 0;
            __delay_ms(20);
            INTCONbits.TMR0IF = 0;
        }
    }
}


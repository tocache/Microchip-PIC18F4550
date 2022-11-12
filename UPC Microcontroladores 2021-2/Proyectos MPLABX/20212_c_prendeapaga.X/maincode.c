#include "cabecera.h"
#define _XTAL_FREQ 4000000UL

void configuro(void){
    TRISC = 0xFE;           //RC0 como salida
    OSCCONbits.IRCF2 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF0 = 0;   //INTOSC a 4MHz
}

void main(void) {
    configuro();            //Funcion configuro
    while(1){               //Bluce infinito
        LATCbits.LC0 = 1;   //RC0 en uno
        __delay_ms(100);    //Retardo 100ms
        LATCbits.LC0 = 0;   //RC0 en cero
        __delay_ms(100);    //Retardo 100ms
        LATCbits.LC0 = 1;   //RC0 en uno
        __delay_ms(100);    //Retardo 100ms
        LATCbits.LC0 = 0;   //RC0 en cero
        __delay_ms(100);    //Retardo 100ms
        LATCbits.LC0 = 1;   //RC0 en uno
        __delay_ms(100);    //Retardo 100ms
        LATCbits.LC0 = 0;   //RC0 en cero
        __delay_ms(1000);    //Retardo 100ms
    }
}

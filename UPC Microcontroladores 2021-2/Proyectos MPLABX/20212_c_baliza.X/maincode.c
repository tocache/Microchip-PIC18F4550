#include "cabecera.h"
#define _XTAL_FREQ 4000000UL    //XTAL de 4MHz

void configuro(void){
    OSCCONbits.IRCF2 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF0 = 0;   //INTOSC a 4MHZ
    TRISDbits.RD0 = 0;      //RD0 como salida
    //TRISD = 0xFE;
}

void main(void) {
    configuro();            //Llamada a funcion configuro
    while(1){
        LATDbits.LD0 = 1;   //RD0 en uno
        __delay_ms(100);    //Retardo de 100ms
        LATDbits.LD0 = 0;   //RD0 a cero
        __delay_ms(800);    //Retardo de 800ms
    }
}

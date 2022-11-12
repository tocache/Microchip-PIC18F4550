#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    TRISCbits.RC0 = 0;  //RC0 como salida
}

void main(void) {
    configuracion();    /*llamada a funcion configuracion()*/
    while(1){
        LATCbits.LC0 = 1;   //encendemos el LED en RC0
        __delay_ms(100);       //pausa de 100ms
        LATCbits.LC0 = 0;   //apagamos el LED en RC0
        __delay_ms(1000);      //pausa de 1000ms
    }
}

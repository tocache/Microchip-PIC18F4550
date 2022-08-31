#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

//Declaracion de variables globales
unsigned char cuenta = 0;
//unsigned char tabla_7s[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67};
unsigned char holaupc[] = {0x76, 0x3F, 0x38, 0x77, 0x00, 0x3E, 0x73, 0x39, 0x00};
//                          H      O     L     A           U    P      C

void configuro(void){
    TRISD = 0x80;   //RD0:RD6 son salidas
}

unsigned char invertida(unsigned char dato){
    unsigned char salida = 0;
    salida = ((dato << 3) & 0x38) + ((dato >> 3) & 0x07) + (dato & 0x40);
    return  salida;
}

void main(void) {
    configuro();
    while(1){
        if (PORTCbits.RC0 ==1){
            LATD = invertida(holaupc[cuenta]);
        }
        else{
            LATD = holaupc[cuenta];
        }
        __delay_ms(300);
        if (cuenta == 8){
            cuenta = 0;
        }
        else{
            cuenta++;            
        }
    }
}

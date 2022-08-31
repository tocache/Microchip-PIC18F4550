#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char msg[] = {0x76, 0x3F, 0x38, 0x77, 0x00, 0x3E, 0x73, 0x39, 0x00};

void configuro(void){
    TRISD = 0x80;       //RD0:RD6 son salidas
}

unsigned char de_cabeza(unsigned char dato){
    unsigned char salida = 0;
    salida = ((dato << 3) & 0x38) + ((dato >> 3) & 0x07) + (dato & 0x40);
    return salida;
}

void main(void) {
    configuro();
    while(1){
        unsigned char xvar = 0;
        for(xvar=0;xvar<9;xvar++){
            if(PORTCbits.RC0 == 1){
                LATD = de_cabeza(msg[xvar]);                
            }
            else{
                LATD = msg[xvar];
            }
            __delay_ms(300);
        }
    }
}

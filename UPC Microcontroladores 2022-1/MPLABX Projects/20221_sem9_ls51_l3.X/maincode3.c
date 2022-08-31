#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char msg[] = {0x76, 0x3F, 0x38, 0x77, 0x00, 0x3E, 0x73, 0x39, 0x00};

void configuro(void){
    TRISD = 0x80;       //RD0:RD6 son salidas
}

unsigned char de_cabeza(unsigned char dato){
    unsigned char temp1 = 0;
    unsigned char temp2 = 0;
    unsigned char temp3 = 0;
    unsigned char salida = 0;
    temp1 = dato << 3;
    temp1 = temp1 & 0x38;
    temp2 = dato >> 3;
    temp2 = temp2 & 0x07;
    temp3 = dato & 0x40;
    salida = temp1 + temp2 + temp3;
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

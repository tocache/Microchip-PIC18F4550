#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

//unsigned char msg_1[] = {0x76, 0x3F, 0x38, 0x77, 0x00, 0x3E, 0x73, 0x39, 0x00};
unsigned char msg_1[] = {0x79, 0x38, 0x38, 0x77, 0x00, 0x54, 0x5c, 0x00, 0x78, 0x79, 0x00, 0x77, 0x37, 0x77, 0x00};

void configuro(void){
    TRISD = 0x80;      //RD0:RD6 son salidas
}

unsigned char de_cabeza(unsigned char dato){
    unsigned char salida = 0;
    salida = ((dato << 3) & 0x38) + ((dato >> 3) & 0x07) + (dato & 0x40);
    return salida;
}

void main(void) {
    configuro();
    while(1){
        unsigned char x_var = 0;
        for(x_var=0;x_var<15;x_var++){
            if(PORTCbits.RC0 == 1){
                LATD = de_cabeza(msg_1[x_var]);
            }
            else{
                LATD = msg_1[x_var];
            }
            __delay_ms(400);
        }
    }
}

/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on May 16, 2022, 5:58 PM
 */

#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char cuenta = 0;
unsigned char tabla_7s[]={0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67};

void configuro(void){
    TRISDbits.RD1 = 0;  //RD1 es salida
    TRISDbits.RD6 = 0;  //RD6 es salida
    TRISB = 0x80;       //RB0-RB6 como salidas
}

unsigned char invertido(unsigned char dato){
    unsigned char tempf = 0;
    tempf = ((dato << 3) & 0x38) + ((dato >> 3) & 0x07) + (dato & 0x40);
    return tempf;
}

void main(void) {
    configuro();
    while(1){
        LATDbits.LD1 = 1;
        __delay_ms(150);
        LATDbits.LD6 = 1;
        __delay_ms(150);
        LATDbits.LD1 = 0;
        __delay_ms(150);
        LATDbits.LD6 = 0;
        __delay_ms(150);
        //LATB = 0x3F;
        LATB = invertido(tabla_7s[cuenta]);
        __delay_ms(150);
        if (cuenta == 9){
            cuenta = 0;
        }
        else{
            cuenta++;
        }

    }
}

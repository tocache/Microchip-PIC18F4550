#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuro(void){
    ADCON1 = 0x0F;      //Todos en digital
    TRISEbits.RE0 = 0;  //RE0 como salida
}

void main(void) {
    unsigned char entrada = 0;
    configuro();
    while(1){
        entrada = PORTB & 0x03;
        switch(entrada){
            case 0:
                LATEbits.LE0 = 1;
                __delay_us(1000);
                LATEbits.LE0 = 0;
                __delay_us(19000);
                break;
            case 1:
                LATEbits.LE0 = 1;
                __delay_us(1250);
                LATEbits.LE0 = 0;
                __delay_us(18750);
                break;
            case 2:
                LATEbits.LE0 = 1;
                __delay_us(1750);
                LATEbits.LE0 = 0;
                __delay_us(18250);
                break;
            case 3:
                LATEbits.LE0 = 1;
                __delay_us(2000);
                LATEbits.LE0 = 0;
                __delay_us(18000);
                break;
            default:
                break;
        }       
    }
}

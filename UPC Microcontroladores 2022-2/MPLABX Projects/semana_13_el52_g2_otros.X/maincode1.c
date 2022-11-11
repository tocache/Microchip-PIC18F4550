/*
 * File:   maincode1.c
 * Author: Kalun Lau
 *
 * Created on November 10, 2022, 6:56 PM
 */

#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISE = 0xF8;
    INTCON2bits.RBPU = 0;
}

void main(void) {
    configuro();
    while(1){
        if(PORTBbits.RB0 == 0){
            LATE = 0x00;
            __delay_ms(100);
            LATE = 0x07;
            __delay_ms(100);
        }
        else{
            LATE = 0x00;
        }
    }
}

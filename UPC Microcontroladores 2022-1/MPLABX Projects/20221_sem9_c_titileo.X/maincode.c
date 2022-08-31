/*
 * File:   maincode.c
 * Author: Kalun Lau
 * Programa para prender y apagar un LED enm RD1 con retardos de 200ms
 * Created on May 16, 2022, 12:25 PM
 */

#include <xc.h>
#include "cabecera.h"

#define _XTAL_FREQ 48000000UL

void configuracion(void){
    TRISD = 0xFD;   //RD1 esta como salida
}

void main(void) {
    configuracion();
    while(1){
        LATD = 0x02;
        __delay_ms(200);
        LATD = 0x00;
        __delay_ms(200);
    }
}

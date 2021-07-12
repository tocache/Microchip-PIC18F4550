/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on May 25, 2021, 8:39 PM
 */

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void init_conf(void){
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    T2CON = 0x45;
    PR2 = 188;
    PIE1bits.TMR2IE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
}

void main(void) {
    init_conf();
    while(1);
}

void __interrupt() TMR2_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}
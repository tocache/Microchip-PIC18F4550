#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    LATEbits.LE0 = 0;
}

void TMR0_config(void){
    T0CON = 0x81;
    INTCON = 0xA0;
}

void main(void) {
    configuro();
    TMR0_config();
    while(1);
}

void __interrupt() TMR0_ISR(void){
    if(PORTEbits.RE0 == 0){
        LATEbits.LE0 = 1;
        TMR0H = 0xF4;
        TMR0L = 0x48;
    }
    else{
        LATEbits.LE0 = 0;
        TMR0H = 0x21;
        TMR0L = 0x58;
    }
    INTCONbits.TMR0IF = 0;
}
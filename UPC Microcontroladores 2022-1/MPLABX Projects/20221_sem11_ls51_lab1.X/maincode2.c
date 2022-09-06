#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void INIT_config(void){
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    LATEbits.LE0 = 0;
}

void TMR0_config(void){
    T0CON = 0x81;
    INTCON = 0xA0;
}

void main(void) {
    INIT_config();
    TMR0_config();
    while(1){
        
    }
}

void __interrupt() TMR0_ISR(void){
    if(PORTBbits.RB0 == 1){
        if(PORTEbits.RE0 == 0){
            LATEbits.LE0 = 1;
            TMR0H = 0xE8;
            TMR0L = 0x90;
        }
        else{
            LATEbits.LE0 = 0;
            TMR0H = 0x2D;
            TMR0L = 0x10;
        }
    }
    else{
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
    }
    INTCONbits.TMR0IF = 0;
}

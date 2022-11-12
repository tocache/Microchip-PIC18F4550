#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void tmr2_conf(void){
    T2CON = 0x45;
    PR2 = 188;
}

void configuracion(void){
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    PIE1bits.TMR2IE = 1;    //Habilitador de ints de TMR2
    INTCONbits.PEIE = 1;    //Habilitador de ints de perifericos
    INTCONbits.GIE = 1;     //Habilitador global de ints
}

void main(void) {
    configuracion();
    tmr2_conf();
    while(1){
    }
}

void __interrupt() TMR2_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;
    //asm("btg LATE, 0");             //in-line assembly
    PIR1bits.TMR2IF = 0;
}
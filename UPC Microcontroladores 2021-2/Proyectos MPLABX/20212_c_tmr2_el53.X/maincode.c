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
}

void main(void) {
    configuracion();
    tmr2_conf();
    while(1){
        while(PIR1bits.TMR2IF == 0);
        //LATEbits.LE0 = !LATEbits.LE0;
        asm("btg LATE, 0");             //in-line assembly
        PIR1bits.TMR2IF = 0;
    }
}

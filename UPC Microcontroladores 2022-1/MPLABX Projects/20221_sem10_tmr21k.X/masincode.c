#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    T2CON = 0x3D;
    PR2 = 186;
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR2IE = 1;
}

void main(void) {
    configuro();
    while(1);
}

void __interrupt() TMR2_ISR(void){
//    LATEbits.LE0 = !LATEbits.LE0;   //basculación de RE0
//    PIR1bits.TMR2IF = 0;            //bajando bandera TMR2IF
    asm("btg LATE, 0");                 //basculación de RE0
    asm("bcf PIR1, 1");                 //bajando bandera TMR2IF
}

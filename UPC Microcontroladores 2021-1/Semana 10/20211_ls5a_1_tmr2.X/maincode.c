#include <xc.h>
#include "cabecera.h"

void init_conf(void){
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    T2CON = 0x45;
    PR2 = 188;
}

void main(void) {
    init_conf();
    while(1){
        while(PIR1bits.TMR2IF == 0);
        LATEbits.LE0 = !LATEbits.LE0;
        PIR1bits.TMR2IF = 0;
    }
}

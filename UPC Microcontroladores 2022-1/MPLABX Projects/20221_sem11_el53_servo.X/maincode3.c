#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISBbits.RB7 = 0;
    T0CON = 0xC6;
}

void main(void) {
    configuro();
    while(1){
        if(PORTBbits.RB0 == 1){
            LATBbits.LB7 = 1;
            TMR0L = 162;
            while(INTCONbits.TMR0IF == 0);
            LATBbits.LB7 = 0;
            __delay_us(20000);
            INTCONbits.TMR0IF = 0;
        }
        else{
            LATBbits.LB7 = 1;
            TMR0L = 68;
            while(INTCONbits.TMR0IF == 0);
            LATBbits.LB7 = 0;
            __delay_us(20000);
            INTCONbits.TMR0IF = 0;
        }
    }
}

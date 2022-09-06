#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISBbits.RB7 = 0;
}

void main(void) {
    configuro();
    while(1){
        if(PORTBbits.RB0 == 1){
            LATBbits.LB7 = 1;
            __delay_us(2000);
            LATBbits.LB7 = 0;
            __delay_us(18000);
        }
        else{
            LATBbits.LB7 = 1;
            __delay_us(1500);
            LATBbits.LB7 = 0;
            __delay_us(18500);
        }
    }
}

#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void init_conf(void){
    ADCON1 = 0x0F;          //All digital I/O
    TRISBbits.RB5 = 0;      //RB5 an output
    TRISBbits.RB4 = 0;      //RB5 an output
}

void main(void) {
    init_conf();
    while(1){
        unsigned int x=0;
        for(x=0;x<7;x++){
            LATBbits.LB5 = 1;
            __delay_us(1000);
            LATBbits.LB5 = 0;
            __delay_us(19000);
        }
        for(x=0;x<7;x++){
            LATBbits.LB4 = 1;
            __delay_us(1000);
            LATBbits.LB4 = 0;
            __delay_us(19000);
        }        
        for(x=0;x<7;x++){
            LATBbits.LB5 = 1;
            __delay_us(1700);
            LATBbits.LB5 = 0;
            __delay_us(18300);
        }
        for(x=0;x<7;x++){
            LATBbits.LB4 = 1;
            __delay_us(1700);
            LATBbits.LB4 = 0;
            __delay_us(18300);
        }        
        for(x=0;x<7;x++){
            LATBbits.LB5 = 1;
            __delay_us(2200);
            LATBbits.LB5 = 0;
            __delay_us(17800);
        }
        for(x=0;x<7;x++){
            LATBbits.LB4 = 1;
            __delay_us(2200);
            LATBbits.LB4 = 0;
            __delay_us(17800);
        }          
        for(x=0;x<7;x++){
            LATBbits.LB5 = 1;
            __delay_us(1700);
            LATBbits.LB5 = 0;
            __delay_us(18300);
        }
        for(x=0;x<7;x++){
            LATBbits.LB4 = 1;
            __delay_us(1700);
            LATBbits.LB4 = 0;
            __delay_us(18300);
        }        
    }
}

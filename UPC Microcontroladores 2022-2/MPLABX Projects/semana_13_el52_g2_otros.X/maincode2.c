#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

unsigned char visual[]={0x01,0x02,0x04,0x02};

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISE = 0xF8;
    INTCON2bits.RBPU = 0;
}

void main(void) {
    configuro();
    while(1){
        if(PORTBbits.RB0 == 0){
            unsigned char x;
            for(x=0;x<4;x++){
                LATE = visual[x];
                __delay_ms(100);
            }
        }
        else{
            LATE = 0x00;
        }
    }
}

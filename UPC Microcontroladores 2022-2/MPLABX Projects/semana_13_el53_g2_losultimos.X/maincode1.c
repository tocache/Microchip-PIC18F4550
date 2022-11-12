#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

unsigned char efectos[]={0x02,0x05,0x04,0x02,0x01};

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    CMCON = 0x07;
    CVRCON = 0x00;
    TRISE = 0xF8;
}

void main(void) {
    configuro();
    while(1){
        unsigned char x;
        for(x=0;x<5;x++){
            LATE=efectos[x];
            __delay_ms(150);
        }
    }
}

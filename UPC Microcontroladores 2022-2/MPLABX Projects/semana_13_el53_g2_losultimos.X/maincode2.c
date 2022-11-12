#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

unsigned char efectos[]={0x02,0x05,0x01,
                        0x02,0x04,0x02,
                        0x01,0x04,0x00,
                        0x07,0x00,0x01,
                        0x02,0x03,0x04,
                        0x05,0x06,0x07,
                        0x06,0x05,0x04,
                        0x03,0x02,0x01};
unsigned char estado_vis=0;
unsigned char estado_vel=0;

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    CMCON = 0x07;
    CVRCON = 0x00;
    TRISE = 0xF8;
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
}

void main(void) {
    configuro();
    while(1){
        unsigned char x;
        switch(estado_vis){
            case 0:
                for(x=0;x<2;x++){
                    LATE=efectos[x];
                    __delay_ms(150);
                }
                break;
            case 1:
                for(x=2;x<6;x++){
                    LATE=efectos[x];
                    __delay_ms(150);
                }
                break;
            case 2:
                for(x=6;x<8;x++){
                    LATE=efectos[x];
                    __delay_ms(150);
                }
                break;
            case 3:
                for(x=8;x<10;x++){
                    LATE=efectos[x];
                    __delay_ms(150);
                }
                break;
            case 4:
                for(x=10;x<18;x++){
                    LATE=efectos[x];
                    __delay_ms(150);
                }
                break;
            case 5:
                for(x=17;x<24;x++){
                    LATE=efectos[x];
                    __delay_ms(150);
                }
                break;
        }
    }
}

void __interrupt() INT0_ISR(){
    INTCONbits.INT0IF = 0;
    if(estado_vis == 5){
        estado_vis = 0;
    }
    else{
        estado_vis++;
    }
}

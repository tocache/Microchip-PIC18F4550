#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 8000000UL

unsigned char efecto[] = {0x01, 0x02, 0x04, 0x02, 0x03, 0x06, 0x00, 0x07};
unsigned char estado = 0;

void configuro(void){
    OSCCON = 0x70;  //Reloj a 8MHz
    ADCON1 = 0x0F;  //Todos los ANx como digitales
    TRISE = 0xF8;   //RE0:RE2 como salidas
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
}

void main(void) {
    configuro();
    while(1){
        unsigned char x;
        switch(estado){
            case 0:
                for(x=0;x<4;x++){
                    LATE = efecto[x];
                    __delay_ms(200);                    
                }
                break;
            case 1:
                for(x=4;x<6;x++){
                    LATE = efecto[x];
                    __delay_ms(200);                    
                }
                break;
            case 2:
                for(x=6;x<8;x++){
                    LATE = efecto[x];
                    __delay_ms(200);                    
                }
                break;
        }
    }
}

void __interrupt() INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado == 2){
        estado = 0;
    }
    else{
        estado++;
    }
    __delay_ms(90);
}
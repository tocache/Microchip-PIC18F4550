#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

const unsigned char mensaje[]={"Hola mundo!"};
unsigned char indicador = 0;

void EUSART_conf(){
    SPBRG = 77;
    RCSTAbits.SPEN = 1;
    TXSTAbits.TXEN = 1;
}

void main(void) {
    EUSART_conf();
    while(1){
        if (PORTBbits.RB0 == 1 && indicador == 0){
            unsigned char x=0;
            for(x=0;x<11;x++){
                TXREG = mensaje[x];
                while(TXSTAbits.TRMT == 0);
                __delay_ms(100);
            }
            TXREG = 0x0A;       //new line
            while(TXSTAbits.TRMT == 0);
            TXREG = 0x0D;       //carriage return
            while(TXSTAbits.TRMT == 0);
            indicador = 1;
        }
        else if(PORTBbits.RB0 == 0 && indicador == 1){
            indicador = 0;
        }
    }
}

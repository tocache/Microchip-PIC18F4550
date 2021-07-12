#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char mensajon1[]={"Mucho demoran, apuren pues"};
unsigned char mensajon2[]={"Se nos va la hora!"};

void EUSART_conf(void){
    SPBRG = 77;             //Vtx 9600
    RCSTAbits.SPEN = 1;     //Encendemos el EUSART
    TXSTAbits.TXEN = 1;     //Encendemos el transmisor del EUSART
}

void main(void) {
    EUSART_conf();
    unsigned char x=0;
    for(x=0;x<26;x++){
        TXREG = mensajon1[x];
        while(TXSTAbits.TRMT == 0);
        __delay_ms(100);
    }
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
    for(x=0;x<18;x++){
        TXREG = mensajon2[x];
        while(TXSTAbits.TRMT == 0);
        __delay_ms(100);
    }    
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);
    while(1);
}

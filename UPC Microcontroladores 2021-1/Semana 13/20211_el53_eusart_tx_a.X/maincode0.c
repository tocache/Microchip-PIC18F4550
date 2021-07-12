#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void EUSART_conf(void){
    SPBRG = 77;             //Vtx 9600
    RCSTAbits.SPEN = 1;     //Encendemos el EUSART
    TXSTAbits.TXEN = 1;     //Encendemos el transmisor del EUSART
}

void main(void) {
    EUSART_conf();
    TXREG = 'H';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'o';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'l';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'a';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = ' ';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'm';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'u';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'n';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'd';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = 'o';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    TXREG = '!';
    while(TXSTAbits.TRMT == 0);
    __delay_ms(100);
    while(1);
}

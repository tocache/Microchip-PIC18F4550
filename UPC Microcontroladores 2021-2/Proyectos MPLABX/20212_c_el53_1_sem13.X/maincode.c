#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void init_conf(void){
    
}

void EUSART_conf(void){
    TRISCbits.RC6 = 0;       //RC6 como salida (TX del EUSART)
    SPBRGH = 0;
    SPBRG = 77;             //Baudrate = 9600
    RCSTAbits.SPEN = 1;     //Puerto serial encendido
    TXSTAbits.TXEN = 1;     //Transmisor encendido
}

void main(void) {
    init_conf();
    EUSART_conf();
    TXREG = 0x48;           //Letra H en ASCII
    while(1);
}

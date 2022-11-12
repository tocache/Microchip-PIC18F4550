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
    __delay_ms(500);
    EUSART_conf();
    TXREG = 'H';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = 'o';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = 'l';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = 'a';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = ' ';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = 'M';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = 'u';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx
    TXREG = 'n';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx    
    TXREG = 'd';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx    
    TXREG = 'o';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx    
    TXREG = '!';           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx    
    TXREG = 0x0A;           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx    
    TXREG = 0x0D;           //Letra H en ASCII
    while(TXSTAbits.TRMT == 0); //Esperar a que termine de tx    
    while(1);
}

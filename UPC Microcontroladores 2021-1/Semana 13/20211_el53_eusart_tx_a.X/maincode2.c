#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

const unsigned char mensaje1[]={"Mi nombre es Kalun Lau"};
const unsigned char mensaje2[]={"UPC Electronica Mecatronica"};

void init_conf(void){
    INTCONbits.GIE = 1;     //interruptor global on
    INTCONbits.PEIE = 1;    //interruptor de perifericos on
    PIE1bits.RCIE = 1;      //habilitador de int del receptor del EUSART
    TRISDbits.RD0 = 0;
    TRISDbits.RD1 = 0;
}

void EUSART_conf(void){
    SPBRG = 77;             //Vtx 9600
    RCSTAbits.SPEN = 1;     //Encendemos el EUSART
    TXSTAbits.TXEN = 1;     //Encendemos el transmisor del EUSART
    RCSTAbits.CREN = 1;     //Encendemos el receptor del EUSART
}

void SERIAL_ESCRIBE_MENSAJE(const unsigned char *cadena){
    unsigned char tam=0;
    tam = strlen(cadena);
    unsigned char x=0;
    for(x=0;x<tam;x++){
        TXREG = cadena[x];
        while (TXSTAbits.TRMT == 0);
    }
}

void SERIAL_NEXTLINE(void){
    TXREG = 0x0A;
    while (TXSTAbits.TRMT == 0);
    TXREG = 0x0D;
    while (TXSTAbits.TRMT == 0);
}

void main(void) {
    init_conf();
    EUSART_conf();
    SERIAL_ESCRIBE_MENSAJE(mensaje1);
    SERIAL_NEXTLINE();
    SERIAL_ESCRIBE_MENSAJE(mensaje2);
    SERIAL_NEXTLINE();
    while(1);
}

void __interrupt() EUSART_RX_ISR(void){
    PIR1bits.RCIF = 0;
    switch(RCREG){
        case '1':
            LATDbits.LD0 = 1;
            SERIAL_ESCRIBE_MENSAJE("Tecla 1 presionada");
            SERIAL_NEXTLINE();
            break;
        case '2':
            LATDbits.LD0 = 0;
            SERIAL_ESCRIBE_MENSAJE("Tecla 2 presionada");
            SERIAL_NEXTLINE();
            break;
        case '3':
            LATDbits.LD1 = 1;
            SERIAL_ESCRIBE_MENSAJE("Tecla 3 presionada");
            SERIAL_NEXTLINE();
            break;
        case '4':
            LATDbits.LD1 = 0;
            SERIAL_ESCRIBE_MENSAJE("Tecla 4 presionada");
            SERIAL_NEXTLINE();
            break;
        default:
            SERIAL_ESCRIBE_MENSAJE("Tecla erronea");
            SERIAL_NEXTLINE();
    }
}

#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

const unsigned char mensaje1[] = {"Ejercicio Jueves"};

EUSART_conf(void){
    SPBRG = 77;                 //Vtx 9600
    RCSTAbits.SPEN = 1;         //EUSART encendido
    TXSTAbits.TXEN = 1;         //EUSART Tx encendido
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
    EUSART_conf();
    SERIAL_ESCRIBE_MENSAJE(mensaje1);
    SERIAL_NEXTLINE();
    while(1);
}

#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

const unsigned char mensaje1[] = {"Ejercicio Jueves"};
const unsigned char boton1[] = {"Boton INT0 presionado"};

INIT_conf(void){
    INTCONbits.GIE = 1;         //Interruptor global encendido
    INTCONbits.INT0IE = 1;      //INT0 habilitado
}

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
    INIT_conf();
    EUSART_conf();
    SERIAL_ESCRIBE_MENSAJE(mensaje1);
    SERIAL_NEXTLINE();
    while(1);
}

void __interrupt() INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    __delay_ms(50);
    SERIAL_ESCRIBE_MENSAJE(boton1);
    SERIAL_NEXTLINE();
}
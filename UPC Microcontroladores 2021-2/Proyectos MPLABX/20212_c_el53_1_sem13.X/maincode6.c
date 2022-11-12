#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

const unsigned char mensaje1[] = {"Ejercicio Control Remoto"};
const unsigned char boton1[] = {"Boton INT0 presionado"};

INIT_conf(void){
    RCONbits.IPEN = 1;          //Prioridades habilitadas
    INTCONbits.GIEH = 1;         //Interruptor global high priority encendido
    INTCONbits.GIEL = 1;        //Interruptor global low priority encendido
    INTCONbits.INT0IE = 1;      //INT0 habilitado
    PIE1bits.RCIE = 1;          //EUSART Rx habilitado
    IPR1bits.RCIP = 0;          //EUSART Rx va a low priority
    TRISDbits.RD0 = 0;          //RD0 salida
    TRISDbits.RD1 = 0;          //RD1 salida
}

EUSART_conf(void){
    SPBRG = 77;                 //Vtx 9600
    RCSTAbits.SPEN = 1;         //EUSART encendido
    TXSTAbits.TXEN = 1;         //EUSART Tx encendido
    RCSTAbits.CREN = 1;         //EUSART Rx encendido
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
    __delay_ms(500);
    INIT_conf();
    EUSART_conf();
    SERIAL_ESCRIBE_MENSAJE(mensaje1);
    SERIAL_NEXTLINE();
    while(1);
}

void __interrupt(high_priority) INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    __delay_ms(50);
    SERIAL_ESCRIBE_MENSAJE(boton1);
    SERIAL_NEXTLINE();
}

void __interrupt(low_priority) EUSART_RX_ISR(void){
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
        case '5':
            LATDbits.LD0 = 1;
            LATDbits.LD1 = 1;
            SERIAL_ESCRIBE_MENSAJE("Tecla 5 presionada");
            SERIAL_NEXTLINE();
            break;
        case '6':
            LATDbits.LD0 = 0;
            LATDbits.LD1 = 0;
            SERIAL_ESCRIBE_MENSAJE("Tecla 6 presionada");
            SERIAL_NEXTLINE();
            break;            
        default:
            SERIAL_ESCRIBE_MENSAJE("Tecla erronea");
            SERIAL_NEXTLINE();
    }
}
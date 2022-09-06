#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char mensaje[] = {"La ingenieria electronica es chevere al igual que la ingenieria mectronica"};

void EUSART_config(void){
    TRISCbits.RC6 = 0;      //RC6 habilitado como salida (Tx)
    SPBRG = 77;             //9600 Vtx
    RCSTAbits.SPEN = 1;     //Activamos el módulo de comm serial
    TXSTAbits.TXEN = 1;     //Activamos el transmisor
}

void EUSART_newline(void){
    TXREG = 0x0A;                   //nueva linea
    while(TXSTAbits.TRMT == 0);     //pregunto si ya se terminó de enviar
    TXREG = 0x0D;                   //retorno de carro
    while(TXSTAbits.TRMT == 0);     //pregunto si ya se terminó de enviar
}

void EUSART_escribemensaje(const unsigned char *entrada){
    unsigned char x;
    for(x=0;x<(strlen(entrada));x++){
        TXREG = entrada[x];
        while(TXSTAbits.TRMT == 0);     //pregunto si ya se terminó de enviar
    }
}

void main(void) {
    EUSART_config();
    while(1){
        EUSART_escribemensaje(mensaje);
        EUSART_newline();
        __delay_ms(2000);
    }
}

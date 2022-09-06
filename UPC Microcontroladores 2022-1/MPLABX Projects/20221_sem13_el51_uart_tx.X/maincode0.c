#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char palabra[] = {"Hola mi nombre es Kalun"};

void EUSART_config(void){
    TRISCbits.RC6 = 0;      //RC6 habilitado como salida (Tx)
    SPBRG = 77;             //9600 Vtx
    RCSTAbits.SPEN = 1;     //Activamos el módulo de comm serial
    TXSTAbits.TXEN = 1;     //Activamos el transmisor
}

void SERIAL_newline(void){
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);          //nueva línea
        TXREG = 0x0D;
        while(TXSTAbits.TRMT == 0);          //retorno de carro
}

void SERIAL_escribemensaje(const unsigned char *vector){
    unsigned int cantidad = 0;
    unsigned char x;
    cantidad = strlen(vector);
    for(x=0;x<cantidad;x++){
        TXREG = vector[x];
        while(TXSTAbits.TRMT == 0);     //preguntto si ya se terminó de enviar
    }
}

void main(void) {
    EUSART_config();
    while(1){
        SERIAL_escribemensaje(palabra);
        SERIAL_newline();
        //__delay_ms(2000);
    }
}

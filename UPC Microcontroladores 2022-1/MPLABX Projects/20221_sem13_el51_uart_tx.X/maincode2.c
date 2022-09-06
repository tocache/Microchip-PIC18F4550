#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

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

unsigned char bienvenida[] = {"Aplicacion de deteccion de boton en RD1"};
unsigned char boton[] = {"Boton en RD1 se ha presionado"};

void main(void) {
    EUSART_config();
    SERIAL_escribemensaje(bienvenida);
    SERIAL_newline();
    while(1){
        if(PORTDbits.RD1 == 1){
            SERIAL_escribemensaje(boton);
            SERIAL_newline();
            __delay_ms(80);             //antirrebote para boton
            while(PORTDbits.RD1 == 1);  //para ver si soltaste el boton
        }
    }
}

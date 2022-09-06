#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char bienvenida1[] = {"Aplicacion para controlar un LED en RD0"};
unsigned char bienvenida2[] = {"Presiona E para encender y A para apagar el LED"};
unsigned char ledon[] = {"LED encendido"};
unsigned char ledof[] = {"LED apagado"};
unsigned char errorkey[] = {"Tecla errada"};

void EUSART_config(void){
    TRISCbits.RC6 = 0;      //RC6 habilitado como salida (Tx)
    SPBRG = 77;             //9600 Vtx
    RCSTAbits.SPEN = 1;     //Activamos el módulo de comm serial
    RCSTAbits.CREN = 1;     //Activamos el receptor
    TXSTAbits.TXEN = 1;     //Activamos el transmisor
}

void INT_config(void){
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.RCIE = 1;      //ints activadas para el Rx del EUSART
}

void SERIAL_newline(void){
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);          //nueva línea
        TXREG = 0x0D;
        while(TXSTAbits.TRMT == 0);          //retorno de carro
}

void SERIAL_escribemensaje(const unsigned char *vector){
    unsigned char cantidad = 0;
    unsigned char x;
    cantidad = strlen(vector);
    for(x=0;x<cantidad;x++){
        TXREG = vector[x];
        while(TXSTAbits.TRMT == 0);     //preguntto si ya se terminó de enviar
    }
}

void main(void) {
    TRISDbits.RD0 = 0;      //RD0 como salida
    EUSART_config();
    INT_config();
    SERIAL_escribemensaje(bienvenida1);
    SERIAL_newline();
    SERIAL_escribemensaje(bienvenida2);
    SERIAL_newline();
    while(1){
    }
}

void __interrupt() EUSART_RX_ISR(void){
    PIR1bits.RCIF = 0;
    if(RCREG == 'E'){
        LATDbits.LD0 = 1;
        SERIAL_escribemensaje(ledon);
        SERIAL_newline();
    }
    else if(RCREG == 'A'){
        LATDbits.LD0 = 0;
        SERIAL_escribemensaje(ledof);
        SERIAL_newline();
    }
    else{
        SERIAL_escribemensaje(errorkey);
        SERIAL_newline();
    }
}

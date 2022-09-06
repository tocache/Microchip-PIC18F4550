#include <xc.h>
#include <string.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char bienvenida1[] = {"Aplicacion para controlar un LED en RD0"};
unsigned char bienvenida2[] = {"Presiona E para encender el LED"};
unsigned char bienvenida3[] = {"Presiona A para apagar el LED"};
unsigned char bienvenida4[] = {"Presiona P para parpadear el LED"};
unsigned char bienvenida5[] = {"Presiona M para visualizar el menu"};
unsigned char ledon[] = {"LED encendido"};
unsigned char ledof[] = {"LED apagado"};
unsigned char ledpa[] = {"LED parpadeando"};
unsigned char errorkey[] = {"Tecla errada"};
unsigned char indicador = 0;

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
    unsigned int cantidad = 0;
    unsigned char x;
    cantidad = strlen(vector);
    for(x=0;x<cantidad;x++){
        TXREG = vector[x];
        while(TXSTAbits.TRMT == 0);     //preguntto si ya se terminó de enviar
    }
}

void MENU_display(void){
    SERIAL_escribemensaje(bienvenida1);
    SERIAL_newline();
    SERIAL_escribemensaje(bienvenida2);
    SERIAL_newline();
    SERIAL_escribemensaje(bienvenida3);
    SERIAL_newline();
    SERIAL_escribemensaje(bienvenida4);
    SERIAL_newline();
    SERIAL_escribemensaje(bienvenida5);
    SERIAL_newline();
}

void main(void) {
    TRISDbits.RD0 = 0;      //RD0 como salida
    EUSART_config();
    INT_config();
    MENU_display();
    while(1){
        if(indicador == 1){
            LATDbits.LD0 = 1;
            __delay_ms(300);
            LATDbits.LD0 = 0;
            __delay_ms(300);
        }
    }
}

void __interrupt() EUSART_RX_ISR(void){
    PIR1bits.RCIF = 0;
    if(RCREG == 'E'){
        LATDbits.LD0 = 1;
        SERIAL_escribemensaje(ledon);
        SERIAL_newline();
        indicador = 0;        
    }
    else if(RCREG == 'A'){
        LATDbits.LD0 = 0;
        SERIAL_escribemensaje(ledof);
        SERIAL_newline();
        indicador = 0;        
    }
    else if(RCREG == 'P'){
        LATDbits.LD0 = 0;
        SERIAL_escribemensaje(ledpa);
        SERIAL_newline();
        indicador = 1;
    }
    else if(RCREG == 'M'){
        MENU_display();
    }    
    else{
        SERIAL_escribemensaje(errorkey);
        SERIAL_newline();
    }
}



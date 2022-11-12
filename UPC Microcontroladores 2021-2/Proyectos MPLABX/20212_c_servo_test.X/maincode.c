#include "cabecera.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

//declaracion de variables globales
unsigned int cuentas = 60000;
unsigned int cuenta_inicial = 0;
unsigned int cuenta_actual = 0;

void carga_cuenta_TMR0(void){
    cuenta_inicial = 65535 - cuentas;
    TMR0H = (cuenta_inicial >> 8) & 0x00FF;
    TMR0L = cuenta_inicial & 0x00FF;
}

void init_conf(void){
    T0CON = 0x80;           //FOSC/4, PSC1:4, 16bit
    cuenta_inicial = 65535 - cuentas;
    TMR0H = (cuenta_inicial >> 8) & 0x00FF;
    TMR0L = cuenta_inicial & 0x00FF;
    INTCON = 0xA0;          //GIE=1, TMR0IE=1
    ADCON1 = 0x0F;          //All digital I/O
    TRISEbits.RE0 = 0;      //RE0 an output
}

void main(void) {
    init_conf();
    while(1){
        cuenta_actual = ((TMR0H << 8) & 0xFF00) + TMR0L;
        if (cuenta_actual >= 30000){
            LATEbits.LE0 = 0;           
        }
    }
}

void __interrupt(high_priority) TMR0_ISR(void){
    carga_cuenta_TMR0();
    LATEbits.LE0 = 1;
    INTCONbits.TMR0IF = 0;
}

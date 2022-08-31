#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

unsigned char mensaje[]={0x3E, 0x73, 0x39};
unsigned char cuenta=0;

void configuro(void){
    TRISB = 0x80;       //RB0:RB6 son salidas (displays de 7seg)
    TRISDbits.RD1 = 0;  //RD1 como salida
    TRISDbits.RD6 = 0;  //RD6 como salida
}
/*
unsigned char invertido(unsigned char dato){
    unsigned char temp1 = 0;
    unsigned char temp2 = 0;
    unsigned char temp3 = 0;
    unsigned char tempf = 0;
    temp1 = (dato << 3) & 0x38;
    temp2 = (dato >> 3) & 0x07;
    temp3 = dato & 0x40;
    tempf = temp1 + temp2 +temp3;
    return tempf;
}
*/

unsigned char invertido(unsigned char dato){
    unsigned char tempf = 0;
    tempf = ((dato << 3) & 0x38) + ((dato >> 3) & 0x07) + (dato & 0x40);
    return tempf;
}

void main(void) {
    configuro();        //llamada a funcion configuro
    while(1){
        LATDbits.LD1 = 1;   //LD1 lo enciendo
        __delay_ms(100);    //retardo de 100ms
        LATDbits.LD1 = 0;   //LD1 lo apago
        __delay_ms(100);    //retardo de 100ms
        LATDbits.LD6 = 1;   //LD6 lo enciendo
        __delay_ms(100);    //retardo de 100ms
        LATDbits.LD6 = 0;   //LD6 lo apago
        __delay_ms(100);    //retardo de 100ms
        //LATB = mensaje[cuenta]; //LATB tendrá el valor dictaminado por el indice cuenta en array mensaje
        LATB = invertido(mensaje[cuenta]);
        if (cuenta == 2){       //pregunto si cuenta = 2
            cuenta = 0;         //verdad: cuenta a cero
        }
        else{                   //falso: cuenta incrementada
            cuenta++;
        }
    }
}

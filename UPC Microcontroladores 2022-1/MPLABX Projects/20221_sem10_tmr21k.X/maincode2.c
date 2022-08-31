#include <xc.h>
#include "cabecera.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    ADCON2 = 0x24;              //8TAD FOSC/4 ADFM=0
    ADCON1 = 0x0E;              //AN0
    ADCON0 = 0x01;              //ADC ON
    T2CON = 0x3D;
    PR2 = 186;
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR2IE = 1;
}

void main(void) {
    configuro();
    while(1){
        ADCON0bits.GODONE = 1;          //Inicio de toma de muestra en AN0
        while(ADCON0bits.GODONE == 1);  //Espera a que termine de convertir
        PR2 = ADRESH;
    };
}

void __interrupt() TMR2_ISR(void){
//    LATEbits.LE0 = !LATEbits.LE0;   //basculación de RE0
//    PIR1bits.TMR2IF = 0;            //bajando bandera TMR2IF
    asm("btg LATE, 0");                 //basculación de RE0
    asm("bcf PIR1, 1");                 //bajando bandera TMR2IF
}

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

//declaracion de variables globales
float calculo_ton = 0;
float calculo_tof = 0;
unsigned int cta_inicial_ton = 0;
unsigned int cta_inicial_tof = 0;

void configuro(void){
    TRISEbits.RE0 = 0;
    LATEbits.LE0 = 0;
}

void ADC_config(void){
    ADCON2 = 0x24;          //8tad fosc/4 adfm=0
    ADCON1 = 0x0D;          //an0 y an1
    ADCON0bits.ADON = 1;    //encendemos el ADC
}

void TMR0_config(void){
    T0CON = 0x81;
    INTCON = 0xA0;
}

void main(void) {
    configuro();
    TMR0_config();
    ADC_config();
    while(1){
        ADCON0 = 0x03;          //tome una muestra en an0
        while(ADCON0bits.GODONE == 1);
        calculo_ton = ((ADRESH * 0.706) * 16.667) + 3000;
        cta_inicial_ton = 65536 - calculo_ton;
        calculo_tof = 57000 - ((ADRESH * 0.706) * 16.667);
        cta_inicial_tof = 65536 - calculo_tof;        
    }
}

void __interrupt() TMR0_ISR(void){
    if(PORTEbits.RE0 == 0){
        LATEbits.LE0 = 1;
        TMR0H = cta_inicial_ton >> 8;
        TMR0L = cta_inicial_ton & 0x00ff;
    }
    else{
        LATEbits.LE0 = 0;
        TMR0H = cta_inicial_tof >> 8;
        TMR0L = cta_inicial_tof & 0x00ff;
    }    
    INTCONbits.TMR0IF = 0;
}

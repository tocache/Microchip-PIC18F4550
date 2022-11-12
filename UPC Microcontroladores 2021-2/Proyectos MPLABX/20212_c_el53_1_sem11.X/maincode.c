#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    ADCON2 = 0x24;      //8TAD FOSC/4 ADFOM=0
    ADCON1 = 0x0D;      //AN0 y AN`1 habilitados como analogicos
    ADCON0bits.ADON = 1; //A/D encendido
    PR2 = 155;          //Frecuencia del PWM: 4.8KHz
    CCPR1L = 77;        //Duty Cycle 50 %
    TRISCbits.RC2 = 0;  //CCP1 como salia
    T2CON = 0x07;       //Encendido de TMR2
    CCP1CON = 0x0C;     //Modo PWM del CCP1
}

void main(void) {
    configuracion();
    while(1){
        ADCON0 = 0x07;  //Seleccionando AN1 y tomando una muestra
        while(ADCON0bits.GODONE == 1);
        CCPR1L = ADRESH;    //Conexion de los MSB
        CCP1CONbits.DC1B1 = (ADRESL >> 7) & 0x01;
        CCP1CONbits.DC1B0 = (ADRESL >> 6) & 0x01;
    }
}

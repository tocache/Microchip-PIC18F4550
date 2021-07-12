#include <xc.h>
#include "cabecera.h"

void init_conf(void){
    //ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    T2CON = 0x45;               //Configuracion de Timer2
    //PR2 = 188;
    PIE1bits.TMR2IE = 1;        //Configuracion de las ints
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
    ADCON2 = 0x24;              //Configuracion del A/D
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void main(void) {
    init_conf();
    while(1){
        unsigned char x;
        unsigned int promedio=0;
        for(x=0;x<40;x++){
            ADCON0bits.GODONE = 1;
            while(ADCON0bits.GODONE == 1);
            promedio = promedio + ADRESH;
        }
        promedio = promedio / 40;
        PR2 = promedio;
    }
}

void __interrupt() TMR2_ISR(){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}
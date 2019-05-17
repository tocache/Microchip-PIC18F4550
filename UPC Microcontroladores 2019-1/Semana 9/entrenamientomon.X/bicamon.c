/*
 * File:   bicamon.c
 * Author: Electronica
 *
 * Created on 16 de mayo de 2019, 07:19 PM
 */

#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 4000000UL    //Para avisarle al XC que estamos con 4MHz de osc

void delaymon(int tiempo){
    for(int i=0;i<tiempo;i++){
        __delay_us(100);
    }
}


void main(void) {
    TRISD = 0xFC;          //Establecemos pines RD0 y RD1 como salida
    LATDbits.LD0 = 1;
    while(1){
        for(int papa=0;papa<100;papa++){
            LATDbits.LD1 = 1;
            delaymon(papa);
            LATDbits.LD1 = 0;
            delaymon(100-papa);
        }
        for(int papa=0;papa<100;papa++){
            LATDbits.LD1 = 1;
            delaymon(100-papa);
            LATDbits.LD1 = 0;
            delaymon(papa);
        }

    }
}

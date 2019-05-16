/*
 * File:   meincoud.c
 * Author: Electronica
 *
 * Created on 16 de mayo de 2019, 04:16 PM
 */
//Este es un comentario
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 4000000UL

void delaymon(int tiempo){
    for (int papa=0; papa<tiempo;papa++){
        __delay_ms(1);
    }
}


void main(void) {
    TRISD = 0xFC;               // Puertos RD0 y RD1 como salida
    LATDbits.LD0 = 1;
    while(1){
        for(int camote=0;camote<10;camote++){
            LATDbits.LD1 = 1;
            delaymon(camote);
            LATDbits.LD1 = 0;
            delaymon(10-camote);
        }    
    }
}

/*
 * File:   sobrevivire.c
 * Author: Administrator
 *
 * Created on 17 de mayo de 2019, 06:17 PM
 */
//Llamada a los bits de configuracion
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 4000000UL    //Velocidad del oscilador

void main(void) {
    TRISD = 0xFC;               //RD0 y RD1 como salidas
    while(1){
        LATDbits.LD0 = 1;
        __delay_ms(200);
        LATDbits.LD0 = 0;
        __delay_ms(200);
        LATDbits.LD1 = 1;
        __delay_ms(200);
        LATDbits.LD1 = 0;
        __delay_ms(200);
    }
}

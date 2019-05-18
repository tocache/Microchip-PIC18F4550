/*
 * File:   veliteitor.c
 * Author: Administrator
 *
 * Created on 17 de mayo de 2019, 03:45 PM
 */
//Directivas de preprocesador
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>

#define _XTAL_FREQ 4000000UL    //Velocidad del oscilador principal

void main(void) {
    TRISDbits.RD0 = 0;          //Pin RD0 como salida
    while(1){
//        LATDbits.LD0 = 1;           //Enviamos 1 logico a RD0
//        __delay_ms(250);
//        LATDbits.LD0 = 0;           //Enviamos 0 logico a RD0
//        __delay_ms(250);
        LATDbits.LD0 = !LATDbits.LD0;
        __delay_ms(250);
    }
}

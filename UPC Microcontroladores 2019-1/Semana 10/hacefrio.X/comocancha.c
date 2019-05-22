/*
 * File:   comocancha.c
 * Author: Electronica
 *
 * Created on 21 de mayo de 2019, 08:52 PM
 */
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 4000000UL

void main(void) {
    PR2 = 249;                  //Periodo del PWM
    CCPR1L = 50;               //Duty Cycle del PWM
    TRISCbits.RC2 = 0;          //Pin RC2 como salida
    T2CON = 0x05;               //Activamos Timer2 y seteamos el PRESCALER
    CCP1CON = 0x0C;              //Colocamos en modo PWM al CCP1        
    while(1)        {
        if(PORTBbits.RB0 == 1){
            CCP1CONbits.DC1B1 = 0;
            CCP1CONbits.DC1B0 = 0;
            CCPR1L = 249;
        }
        else{
            CCPR1L = 50;            
        }
    }
}

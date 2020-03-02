/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on March 2, 2020, 2:28 PM
 */
//This is a comment line
/*This is another comment*/

#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>

#define _XTAL_FREQ 4000000UL    //Define XTAL frequency for XC8 delay routines

void main(void) {
    TRISDbits.RD0 = 0;          //RD0 as output
    while(1){
        LATDbits.LD0 = 1;           //Turn RD0 on
        __delay_ms(500);            //wait for 500msec
        LATDbits.LD0 = 0;           //Turn RD0 off
        __delay_ms(500);            //wait for 500msec
    }
}

/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on March 2, 2020, 4:50 PM
 */
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 4000000UL    //Define XTAL frequency for XC8 delay routines

void arrancaLCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    CURSOR_HOME();
}

void main(void) {
    //Rutina de inicialización para el LCD
    arrancaLCD();
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("C iso la",8);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("biztimaaa",9);
    }    
}
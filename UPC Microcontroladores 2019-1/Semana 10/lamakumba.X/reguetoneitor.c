/*
 * File:   reguetoneitor.c
 * Author: Electronica
 *
 * Created on 22 de mayo de 2019, 11:03 AM
 */

// PIC18F4550 Configuration Bit Settings
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XT_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
#include <xc.h>
#include "LCD.h"

#define _XTAL_FREQ 4000000UL   // Freq = 48MHz

int cuenta = 0;

int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;

void DIGITOS(void){
    digdmi = cuenta / 10000;
    temporal3 = cuenta - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void main(void) {
//    TRISD = 0x80;
    __delay_ms(500);
    LCD_CONFIG();
    __delay_ms(50);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    while(1){
        CURSOR_HOME();
        ESCRIBE_MENSAJE("Funciona pe!",12);
        for(cuenta=0;cuenta<100000;cuenta++){
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Cuenta:",7);
            DIGITOS();
            ENVIA_CHAR(digdmi+0x30);
            ENVIA_CHAR(digmil+0x30);
            ENVIA_CHAR(digcen+0x30);
            ENVIA_CHAR(digdec+0x30);
            ENVIA_CHAR(diguni+0x30);
            __delay_ms(5);
        }
    }
}

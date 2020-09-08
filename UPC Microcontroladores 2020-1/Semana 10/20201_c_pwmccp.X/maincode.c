/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on May 19, 2020, 7:59 PM
 */

// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo 48MHz

void configuracion() {
    PR2 = 155;                   //Para el periodo (freq 25KHz en PWM CCP)
    CCPR1L = 78;                //Para el duty cycle (30%)
    TRISCbits.RC2 = 0;          //Puerto RC2/CCP1 como salida
    T2CON = 0x07;               //Timer2 ON con PreSC 1:16
    CCP1CON = 0x0C;             //CCP1 en modo PWM
}

void main(void) {
    configuracion();
    while(1) {
        if (PORTB == 0x00) {
            CCPR1L = 78;
        }
        if (PORTB == 0x01) {
            CCPR1L = 39;
        }
        if (PORTB == 0x02) {
            CCPR1L = 19;
        }
        if (PORTB == 0x03) {
            CCPR1L = 9;
        }
    }
}
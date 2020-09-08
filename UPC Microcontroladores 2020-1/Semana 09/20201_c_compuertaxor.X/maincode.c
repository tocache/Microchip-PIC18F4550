/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on May 19, 2020, 2:34 PM
 */

// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
// CONFIG1L
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

#define _XTAL_FREQ 48000000UL       //Frecuencia de trabajo 48MHz

void configuracion(void) {
    TRISDbits.RD0 = 0;          //Puerto RD0 como salida
}

void main(void) {
    configuracion();
    while(1) {
        //Bucle infinito
        //Con switch-case
        switch (PORTB & 0x03) {
            case 0x00:
                LATDbits.LD0 = 0;
                break;
            case 0x01:
                LATDbits.LD0 = 1;
                break;
            case 0x02:
                LATDbits.LD0 = 1;
                break;
            case 0x03:
                LATDbits.LD0 = 0;
                break;
        }
    }
}

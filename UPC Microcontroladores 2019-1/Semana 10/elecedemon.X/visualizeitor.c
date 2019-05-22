/*
 * File:   visualizeitor.c
 * Author: Electronica
 *
 * Created on 22 de mayo de 2019, 08:14 AM
 */

// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.
#include <xc.h>
#include "LCD.h"
#include "ADC.h"

#define _XTAL_FREQ 48000000UL   //Freq 48MHz

int canal0 = 0;

int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;

void DIGITOS(void){
    digdmi = canal0 / 10000;
    temporal3 = canal0 - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void main(void) {
    ADC_CONFIG(0);
    __delay_ms(50);
    LCD_CONFIG();               //Configuracion del LCD
    __delay_ms(10);
    BORRAR_LCD();
    __delay_ms(10);
    CURSOR_ONOFF(OFF);
    CURSOR_HOME();
    __delay_ms(10);
//    ENVIA_CHAR('H');
//    ENVIA_CHAR('o');
//    ENVIA_CHAR('l');
//    ENVIA_CHAR('a');
    ESCRIBE_MENSAJE("Microcontroladores", 18);
    while(1){
        canal0 = ADC_CONVERTIR();
        POS_CURSOR(2,0);
        __delay_ms(10);
        DIGITOS();
        ESCRIBE_MENSAJE("ADC:", 4);
        ENVIA_CHAR(digdmi+0x30);
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        __delay_ms(10);

    }
}

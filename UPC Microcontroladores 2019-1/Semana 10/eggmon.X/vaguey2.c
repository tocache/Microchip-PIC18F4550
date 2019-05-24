/*
 * File:   vaguey.c
 * Author: klau
 *
 * Created on 24 de mayo de 2019, 04:00 PM
 */

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
#include "ADC.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

int resultaso = 0;

int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;

void DIGITOS(int valor){
    digdmi = valor / 10000;
    temporal3 = valor - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void main(void) {
    TRISCbits.RC2 = 0;      //Como salida para activar el transistor del backlight del LCD
    LATCbits.LC2 = 1;       //Encendemos el backlight del LCD
    TRISD = 0x00;           //Puertos como salida para el LCD
    __delay_ms(500);        //Retardo para esperar la inicializacion del LCD
    LCD_CONFIG();           //Funcion de inicializacion para el LCD a modo 4bit
    __delay_ms(15);         //Esperamos a que el LCD se configure
    CURSOR_ONOFF(OFF);      //Apagamos el cursor del LCD
    ADC_CONFIG(0);
    while(1){
        CURSOR_HOME();      //Mover el curso a la posicion inicial
        ESCRIBE_MENSAJE("Lectura ADC:", 12);
        resultaso = ADC_CONVERTIR();
        DIGITOS(resultaso);
        POS_CURSOR(2,0);
        ENVIA_CHAR(digdmi+0x30);    //Impresion de resultadomon en el LCD
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
    }
}
/*
 * File:   auxilio.c
 * Author: klau
 *
 * Created on 24 de mayo de 2019, 06:53 PM
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
#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo a 48MHz

int res_adc = 0;

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
    ADC_CONFIG(0);      //Configurando puerto analogico AN0
    TRISCbits.RC2 = 0;  //Pin RC2 como salida
    LATCbits.LC2 = 1;   //Encendemos el backlight del LCD
    TRISD = 0x00;       //Puertos como salida para manejar el LCD
    __delay_ms(500);    //Esperamos a que el LCD inicialice
    LCD_CONFIG();       //Configuracion del LCD para que trabaje a 4bit
    __delay_ms(15);
    CURSOR_ONOFF(OFF);  //Apagamos el cursor
    while(1){
        CURSOR_HOME();  //Mandamos el cursor a la posicion principal
        ESCRIBE_MENSAJE("Leyendo ADC:", 12);
        res_adc = ADC_CONVERTIR();
        DIGITOS(res_adc);
        POS_CURSOR(2,0);            //Cursos a la segunda linea
        ENVIA_CHAR(digdmi+0x30);    //Impresion de resultadomon en el LCD
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
    }
}

        
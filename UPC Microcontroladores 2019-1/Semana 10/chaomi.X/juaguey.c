/*
 * File:   juaguey.c
 * Author: Electronica
 *
 * Created on 23 de mayo de 2019, 05:05 PM
 */
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
//#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config FOSC = XT_XT  // Oscillator Selection bits (XT oscillator, PLL disabled (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)#pragma config ICPRT = OFF      // Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)

#include <xc.h>
#include "LCD.h"
#include "ADC.h"
//#define _XTAL_FREQ 48000000UL  //con PLL
#define _XTAL_FREQ 4000000UL   //sin PLL

int resultado = 0;

int digdmi = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;
int temporal3 = 0;

void DIGITOS(void){
    digdmi = resultado / 10000;
    temporal3 = resultado - (digdmi * 10000);
    digmil = temporal3 / 1000;
    temporal = temporal3 - (digmil * 1000);
    digcen = temporal / 100;
    temporal2 = temporal - (digcen * 100);
    digdec = temporal2 / 10;
    diguni = temporal2 - (digdec * 10);        
}

void main(void) {
    TRISD = 0x00;               //puerto RD como salida para el LCD
    TRISCbits.RC2 = 0;
    LATCbits.LC2 = 1;
    __delay_ms(500);
    LCD_CONFIG();               //Inicializar el LCD
    __delay_ms(15);
    BORRAR_LCD();               //Limpiamos la pantalla
    CURSOR_ONOFF(OFF);          //Apagamos el cursor
    ADC_CONFIG(0);
    while(1){
        CURSOR_HOME();              //Movemos el cursos a home
        ESCRIBE_MENSAJE("Lectura ADC", 11);
        resultado = ADC_CONVERTIR();
        DIGITOS();             //Para sacarle los digitos a la variable resultado
        POS_CURSOR(2, 0);
        ENVIA_CHAR(digdmi+0x30);
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
    }
}

/*
 * File:   basura.c
 * Author: klnla
 *
 * Created on May 28, 2019, 10:49 AM
 */

#pragma config PLLDIV = 1 // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly)) 
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2]) 
#pragma config FOSC = XTPLL_XT // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL)) 
#pragma config PWRT = ON // Power-up Timer Enable bit (PWRT enabled) 
#pragma config BOR = OFF // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software) 
#pragma config WDT = OFF // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
#pragma config CCP2MX = ON // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1) 
#pragma config PBADEN = OFF // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset) 
#pragma config MCLRE = ON // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled) 
#pragma config LVP = OFF // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled) 

#include <xc.h>
#include <pic18f4550.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned int cuentasa =0;

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
    //Rutinas para inicializacion del LCD
    TRISD = 0;
    __delay_ms(500);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);
  
    //Configuracion inicial
    TRISBbits.RB0 = 0;      //pin RD0 como salida
    TRISEbits.RE0 = 0;      //pin RD0 como salida
    T0CON = 0x80;           //Timer0 ON, PSC 1:128, FOSC/4, 16bit
    RCONbits.IPEN = 1;      //Habilitamos las prioridades de interrupcion
    INTCONbits.GIEH = 1;     //Interrupciones globales HP ON
    INTCONbits.GIEL = 1;    //Interrupciones globales LP ON
    INTCONbits.TMR0IE = 1;   //Habilitador de interrupcion de Timer0
    INTCON3bits.INT1E = 1;  //Habilitador de interrupciones de INT1
    INTCON3bits.INT1IP = 0; //Low priority para INT1
    //Repeticion indefinida
    CURSOR_HOME();
    ESCRIBE_MENSAJE("Hola mundo!",11);
    while(1){
        for(cuentasa=0;cuentasa<50000;cuentasa++){
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Cuenta:",7);
            DIGITOS(cuentasa);
            ENVIA_CHAR(digdmi+0x30);    //Impresion de cuentasa en el LCD
            ENVIA_CHAR(digmil+0x30);
            ENVIA_CHAR(digcen+0x30);
            ENVIA_CHAR(digdec+0x30);
            ENVIA_CHAR(diguni+0x30);
        }
    }
}

void __interrupt(high_priority) Timer0(void){
    INTCONbits.TMR0IF = 0;      //bajamos la baderita
    LATBbits.LB0 = !LATBbits.LB0;
}

void __interrupt(low_priority) Int1(void){
    INTCON3bits.INT1F = 0;      //bajamos la baderita
    LATEbits.LE0 = !LATEbits.LE0;
}


/*
 * File:   tonitomon.c
 * Author: klnla
 *
 * Created on May 28, 2019, 6:03 PM
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
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

char estado = 0;  //0 es apagado, 1 es parpadeando

void main(void) {
    //Rutina de inicializacion de LCD
    TRISD = 0;
    TRISEbits.RE0 = 0;
    __delay_ms(500);
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    TRISDbits.RD0 = 0;      //Pin RD0 como salida
    RCONbits.IPEN = 1;      //Habilitamos prioridades en interrupciones
    INTCONbits.GIEH = 1;     //Habilito interrupciones globales
    INTCONbits.GIEL = 1;     //Habilito interrupciones globales
    INTCONbits.INT0IE = 1;  //Habilito la INT0
    INTCONbits.INT0IF = 0;  //Forzamos la bandera a 0 en el INT0
    INTCON3bits.INT1E = 1;  //Habilito la INT1
    INTCON3bits.INT1IP = 0; //INT1 como interrupcion de baja prioridad
    INTCON3bits.INT1IF = 0; //Bajamos la baderita de INT1
    CURSOR_HOME();
    ESCRIBE_MENSAJE("Micreitors 20191",16);
    
    while(1){
        if (estado == 1){
            LATEbits.LE0 = 1;
            __delay_ms(10);
            LATEbits.LE0 = 0;
            __delay_ms(10);        
        }
        else{
            LATEbits.LE0 = 0;
        }
    }
}

void __interrupt(high_priority) Int0(void){
    INTCONbits.INT0IF = 0;
    estado = !estado;
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("Machucaron INT0",15);
}

void __interrupt(low_priority) Int1(void){
    INTCON3bits.INT1IF = 0;
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("Machucaron INT1",15);
}
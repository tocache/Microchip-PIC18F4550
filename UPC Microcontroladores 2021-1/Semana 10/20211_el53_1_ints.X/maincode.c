/*
 * File:   maincode.c
 * Author: Kalun Lau Gan
 *
 * Created on May 25, 2021, 10:52 AM
 */

/*Programa que tiene interrupciones externas y cada una de dellas hace una
función en particular*/

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char indicador = 0;

void init_conf(void){
    RCONbits.IPEN = 1;          //Prioridades habilitadas
    INTCONbits.INT0IE = 1;      //Int0 habilitada
    INTCON3bits.INT1IE = 1;     //Int1 habilitada
    INTCON3bits.INT1IP = 0;     //Int1 se vaya a low priority
    INTCONbits.GIEH = 1;         //Interuptor global de ints HP activado
    INTCONbits.GIEL = 1;         //Interuptor global de ints LP activado
}

void lcd_conf(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    init_conf();
    lcd_conf();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Detector UPC2021",16);
    while(1){
        if (indicador == 1){
            indicador = 0;
            __delay_ms(3000);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("                ",16);
        }
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("Presionaste INT0",16);
    INTCONbits.INT0IF = 0;                      //bajamos la bandera de INT0
    indicador = 1;
}

void __interrupt(low_priority) INT1_ISR(void){
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("Machucaste INT1 ",16);
    INTCON3bits.INT1IF = 0;                     //BAjamos la bandera de INT1
    indicador = 1;
}

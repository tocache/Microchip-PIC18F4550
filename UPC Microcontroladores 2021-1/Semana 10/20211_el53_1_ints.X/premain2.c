/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on May 25, 2021, 8:39 PM
 */

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void lcd_conf(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void init_conf(void){
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    T2CON = 0x45;
    PR2 = 188;
    PIE1bits.TMR2IE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;
    ADCON2 = 0x24;
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void convierte(unsigned int numero){
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    init_conf();
    lcd_conf();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("1KHz Generator",14);
    while(1){
        ADCON0bits.GODONE = 1;
        while(ADCON0bits.GODONE == 1);
        PR2 = ADRESH;
        convierte(PR2);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("PR2:",4);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

void __interrupt() TMR2_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}
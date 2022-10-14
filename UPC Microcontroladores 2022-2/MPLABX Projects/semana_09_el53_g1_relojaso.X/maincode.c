/*
 * File:   maincode.c
 * Author: Alumnos
 *
 * Created on October 14, 2022, 10:12 AM
 */

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISBbits.RB0 = 0;
}

void LCD_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(20);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    LCD_init();
    while(1){
        LATBbits.LB0 = 1;
        __delay_ms(100);
        LATBbits.LB0 = 0;
        __delay_ms(100);
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Viernes Cultural",16);
    }
}

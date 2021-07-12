/*
 * File:   maincode1.c
 * Author: klnla
 *
 * Created on May 19, 2021, 7:52 PM
 */

#include <xc.h>
#include "maincode.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void init_conf(void){
    TRISCbits.RC0 = 0;      //RC0 como salida
    TRISCbits.RC2 = 0;      //RC2 como salida
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    init_conf();
    lcd_init();
    LATCbits.LC2 = 1;
    ESCRIBE_MENSAJE("Hola mundo!", 11);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("Kalun Lau Gan", 13);
    while(1){
        LATCbits.LC0 = 1;
        __delay_ms(250);
        LATCbits.LC0 = 0;
        __delay_ms(250);
    }
}

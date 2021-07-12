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

void init_conf(void){
    RCONbits.IPEN = 1;          //Prioridades habilitadas
    INTCONbits.INT0IE = 1;      //Int0 habilitada
    INTCON3bits.INT1IE = 1;     //Int1 habilitada
    INTCON3bits.INT1IP = 0;     //Int1 se vaya a low priority
    INTCON3bits.INT2IP = 0;      //INT2 como baja prioridad
    INTCON3bits.INT2IE = 1;     //Habilito la INT2    
    INTCONbits.GIEH = 1;         //Interuptor global de ints HP activado
    INTCONbits.GIEL = 1;         //Interuptor global de ints LP activado
    TRISBbits.RB7 = 0;               //RB7 como salida
    TRISCbits.RC2 = 0;
    LATCbits.LC2 = 1;           
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
        LATBbits.LB7 = 1;
        __delay_ms(100);
        LATBbits.LB7 = 0;
        __delay_ms(100);
    };
}

void __interrupt(high_priority) INT0_ISR(void){
    POS_CURSOR(2,0);
    if (INTCON2bits.INTEDG0 == 1) {
        //CURSOR_HOME();
        ESCRIBE_MENSAJE("BTN0 presionado",15); 
        INTCON2bits.INTEDG0 = 0;
    }
    else {
        //CURSOR_HOME();
        ESCRIBE_MENSAJE("BTN0 soltado   ",15); 
        INTCON2bits.INTEDG0 = 1;
    }
    INTCONbits.INT0IF = 0;
}

void __interrupt(low_priority) INT1_ISR(void){
    POS_CURSOR(2,0);
    if (INTCON3bits.INT1IF == 1) {
        if (INTCON2bits.INTEDG1 == 1) {
            //CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN1 presionado",15); 
            INTCON2bits.INTEDG1 = 0;
        }
        else {
            //CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN1 soltado   ",15); 
            INTCON2bits.INTEDG1 = 1;
        }
        INTCON3bits.INT1IF = 0;
    }
    POS_CURSOR(2,0);
    if (INTCON3bits.INT2IF == 1) {
        if (INTCON2bits.INTEDG2 == 1) {
            //CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN2 presionado",15); 
            INTCON2bits.INTEDG2 = 0;
        }
        else {
            //CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN2 soltado   ",15); 
            INTCON2bits.INTEDG2 = 1;
        }
        INTCON3bits.INT2IF = 0;        
    }
}

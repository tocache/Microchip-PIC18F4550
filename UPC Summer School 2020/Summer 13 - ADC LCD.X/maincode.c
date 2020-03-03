/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on March 2, 2020, 4:50 PM
 */
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 4000000UL    //Define XTAL frequency for XC8 delay routines

unsigned int lecturon;
unsigned char millar;
unsigned char centena;
unsigned char decena;
unsigned char unidad;

void arrancaLCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    CURSOR_HOME();
}

void convierte(unsigned int numero){
    millar = numero / 1000;
    centena = numero % 1000 / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    //Rutina de inicialización para el LCD
    arrancaLCD();
    ADCON2 = 0xA4;           //8TAD FOSC/4 ADFM 1
    ADCON1 = 0x0E;         //AN0 enabled VREF+=VDD VREF-=VSS
    ADCON0 = 0x01;          //ADC module enabled        
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Summer School uC",16);
        while(1){
            ADCON0bits.GODONE = 1;
            while(ADCON0bits.GODONE == 1);
            lecturon = (ADRESH << 8) + ADRESL;
            convierte(lecturon);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("CHANNEL AN0:",12);
            ENVIA_CHAR(millar+0x30);
            ENVIA_CHAR(centena+0x30);
            ENVIA_CHAR(decena+0x30);
            ENVIA_CHAR(unidad+0x30);
        }    
}
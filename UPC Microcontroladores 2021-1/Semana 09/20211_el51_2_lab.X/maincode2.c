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

//declaracion de variables globales
unsigned int resultado = 0;
unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void init_conf(void){
    TRISCbits.RC0 = 0;      //RC0 como salida
    TRISCbits.RC2 = 0;      //RC2 como salida
    ADCON2 = 0xA4;
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    d_millar = numero / 10000;
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    init_conf();
    lcd_init();
    LATCbits.LC2 = 1;
    ESCRIBE_MENSAJE("Lectura A/D", 11);
    while(1){
        ADCON0bits.GODONE = 1;          //toma de una muestra en AN0
        while(ADCON0bits.GODONE == 1);
        resultado = (ADRESH << 8) + ADRESL;
        convierte(resultado);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("AN0: ", 5);
        ENVIA_CHAR(d_millar+0x30);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

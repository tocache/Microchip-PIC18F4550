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

unsigned int promedio = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;


void init_conf(void){
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

void lcd_conf(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    init_conf();
    lcd_conf();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("  SqrWave Gen  ",15);
    while(1){
        unsigned char x;
        promedio = 0;                       //Aplicamos filtro de promediación
        for(x=0;x<20;x++){                  //Se toman 20 muestras y se divide entre 20
            ADCON0bits.GODONE = 1;
            while(ADCON0bits.GODONE == 1);
            promedio = promedio + ADRESH;
        }
        promedio = promedio / 20;
        PR2 = promedio;
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("PR2:",4);
        convierte(PR2);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

void __interrupt() TMR2_ISR(void){
    LATEbits.LE0 = !LATEbits.LE0;
    PIR1bits.TMR2IF = 0;
}
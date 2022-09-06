#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

//declaracion de variables globales
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
float temporal = 0;

void configuro(void){
    
}

LCD_config(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

CCP1_config(void){
    PR2 = 155;
    CCPR1L = 78;
    TRISCbits.RC2 = 0;
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

ADC_config(void){
    ADCON2 = 0x24;
    ADCON1 = 0x0D;
    ADCON0bits.ADON = 1;
}

void convierte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void VIS_AN1(void){
    convierte(ADRESH);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("A1:", 3);
    ENVIA_CHAR(centena + 0x30);
    ENVIA_CHAR(decena + 0x30);
    ENVIA_CHAR(unidad + 0x30);
}

void VIS_CCPR1L(void){
    convierte(CCPR1L);
    ESCRIBE_MENSAJE(" CCPR1:", 7);
    ENVIA_CHAR(centena + 0x30);
    ENVIA_CHAR(decena + 0x30);
    ENVIA_CHAR(unidad + 0x30);
}

void VIS_DC(void){
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("Intensidad:", 11);
    convierte(temporal);
    ENVIA_CHAR(centena + 0x30);
    ENVIA_CHAR(decena + 0x30);
    ENVIA_CHAR(unidad + 0x30);
    ENVIA_CHAR('%');
}

void main(void) {
    configuro();
    CCP1_config();
    LCD_config();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("EL51 Lab", 8);
    while(1){
        ADCON0 = 0x07;
        while(ADCON0bits.GODONE == 1);
        //VIS_AN1();
        temporal = ADRESH * 0.61;
        CCPR1L = temporal;
        //VIS_CCPR1L();
        temporal = ADRESH * 0.39;
        VIS_DC();
    }
}

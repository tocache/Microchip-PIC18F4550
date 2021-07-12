#include <xc.h>
#include <stdio.h>
#include "maincode.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

//declaracion de variables globales
unsigned int lm35raw = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
unsigned char o_acento[] = {0x02, 0x04, 0x0Ee, 0x11, 0x11, 0x11, 0x0E, 0x00};
unsigned char thermo[] = {0x04,0x0A,0x0A,0x0E,0x1F,0x1F,0x0E,0x00};
float n_temp_c = 0;
float n_temp_f = 0;

void convierte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void lcd_init(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
    GENERACARACTER(o_acento, 0);
    GENERACARACTER(thermo, 1);
}

void adc_init(void){
    ADCON2 = 0xA4;
    ADCON1 = 0x1B;
    ADCON0 = 0x01;
}

void main(void) {
    lcd_init();
    adc_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Term",4);
    ENVIA_CHAR(0x00);
    ESCRIBE_MENSAJE("metro ", 6);
    ENVIA_CHAR(0x01);
    while(1){
        ADCON0bits.GODONE = 1;      //toma de una muestra en AN0
        while(ADCON0bits.GODONE == 1);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("T0:", 3);
        lm35raw = (ADRESH << 8) + ADRESL; //ADRESH:ADRESL
        n_temp_c = lm35raw / 10.24;
        n_temp_f = (n_temp_c * 9 / 5) + 32;
        convierte(n_temp_c);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(0x0DF);
        ESCRIBE_MENSAJE("C ", 2);
        convierte(n_temp_f);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(0x0DF);
        ESCRIBE_MENSAJE("F", 1);        
    }
}

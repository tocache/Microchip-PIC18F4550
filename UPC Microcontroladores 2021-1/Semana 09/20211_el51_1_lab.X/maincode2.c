
#include <xc.h>
#include "maincode1.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

//declaracion de variables globales
unsigned int ad_resultado = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void init_conf(void){
    TRISCbits.RC2 = 0;      //RC2 como salida
    ADCON2 = 0xA4;
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void lcd_conf(void){
    TRISD = 0x00;           //RD salidas
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    millar = numero /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    init_conf();
    lcd_conf();
    LATCbits.LC2 = 1;       //backlight del LCD encendido
    ESCRIBE_MENSAJE("Lectura ADC:",12);
    while(1){
        ADCON0bits.GODONE = 1;      //Inicio de la conversion en AN0
        while(ADCON0bits.GODONE == 1);
        ad_resultado = (ADRESH << 8) + ADRESL;
        convierte(ad_resultado);
        POS_CURSOR(2,0);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

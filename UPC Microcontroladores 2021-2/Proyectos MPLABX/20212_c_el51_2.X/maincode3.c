#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL    //frecuencia de trabajo 48MHz

//variables globales
unsigned int res_ad = 0;
unsigned int dig_millar = 0;
unsigned int dig_centena = 0;
unsigned int dig_decena = 0;
unsigned int dig_unidad = 0;
float pot = 0;

void configuracion(void){
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

void digbyte(unsigned int dato_in){
    dig_millar = dato_in  / 1000;
    dig_centena = (dato_in % 1000) / 100;
    dig_decena = (dato_in % 100) / 10;
    dig_unidad = dato_in % 10;
}

void main(void) {
    configuracion();
    lcd_init();
    while(1){
        ADCON0bits.GODONE = 1;
        while(ADCON0bits.GODONE == 1);
        res_ad = (ADRESH << 8) + ADRESL;
        pot = res_ad * 0.010;
        digbyte(res_ad);
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Conversion A/D",14);
        __delay_ms(150);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("A0:",3);
        ENVIA_CHAR(dig_millar+0x30);
        ENVIA_CHAR(dig_centena+0x30);
        ENVIA_CHAR(dig_decena+0x30);
        ENVIA_CHAR(dig_unidad+0x30);
        ESCRIBE_MENSAJE(" Pot:",5);
        digbyte(pot);
        ENVIA_CHAR(dig_decena+0x30);
        ENVIA_CHAR(dig_unidad+0x30);
        ESCRIBE_MENSAJE("K",1);
        ENVIA_CHAR(0xF4);
    }
}

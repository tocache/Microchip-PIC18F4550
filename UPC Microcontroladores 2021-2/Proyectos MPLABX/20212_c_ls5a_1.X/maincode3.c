#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

//variables globales
unsigned int res_ad = 0;
unsigned int d_millar = 0;
unsigned int d_centena = 0;
unsigned int d_decena = 0;
unsigned int d_unidad = 0;
float voltaje = 0;

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

void digbyte(unsigned int dato){
    d_millar = dato / 1000;
    d_centena = (dato % 1000) / 100;
    d_decena = (dato % 100) / 10;
    d_unidad = dato % 10;
}

void main(void) {
    configuracion();    /*llamada a funcion configuracion()*/
    lcd_init();
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Lectura ADC",11);
        ADCON0bits.GODONE = 1;
        while(ADCON0bits.GODONE == 1);
        res_ad = (ADRESH << 8) + ADRESL;
        voltaje = res_ad * 0.005;
        digbyte(res_ad);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("AN0:",4);
        ENVIA_CHAR(d_millar+0x30);
        ENVIA_CHAR(d_centena+0x30);
        ENVIA_CHAR(d_decena+0x30);
        ENVIA_CHAR(d_unidad+0x30);
        digbyte(voltaje);
        ESCRIBE_MENSAJE(" Volt:",6);
        ENVIA_CHAR(d_unidad+0x30);
        ESCRIBE_MENSAJE("V",1);
    }
}

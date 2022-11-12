#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

//variables globales
unsigned int res_ad = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;


void configuro(void){
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

void digbyte(unsigned int data_in){
    millar = data_in / 1000;
    centena = (data_in % 1000) / 100;
    decena = (data_in % 100) / 10;
    unidad = data_in % 10;
}

void main(void) {
    configuro();        /*llamada a la funcion configuro*/
    lcd_init();
    while(1){
        ADCON0bits.GODONE = 1;
        while(ADCON0bits.GODONE == 1);
        res_ad = (ADRESH << 8) + ADRESL;
        digbyte(res_ad);
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("UPC-Lectura ADC",15);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Canal AN-0:",11);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

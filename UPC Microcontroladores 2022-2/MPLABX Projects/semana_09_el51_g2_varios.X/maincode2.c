#include <xc.h>
#include "cabacera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char menestron = 167;
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;
//slash slash para comentarios

void configuro(void){};

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void digitos_individuales(unsigned char numero){
    centena = numero / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Hola UPCino", 11);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Menestron: ", 11);
        digitos_individuales(menestron);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
    }
    
}

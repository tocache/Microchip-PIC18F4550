/*Este es el primer ejemplo*/

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char choclo = 236;
unsigned char centena = 0;
unsigned char decena = 0;
unsigned char unidad = 0;

void configuro(void){

}

void individualizar_digitos(unsigned char entrada){
    centena = entrada / 100;
    decena = (entrada % 100) / 10;
    unidad = entrada % 10;
}

void lcd_init(void){
    TRISD = 0x00;       //RD todos como salidas
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void){
    configuro();
    lcd_init();
    while(1){
        POS_CURSOR(1,1);
        ESCRIBE_MENSAJE("Hola UPC",8);
        individualizar_digitos(choclo);
        POS_CURSOR(2,1);
        ESCRIBE_MENSAJE("Choclo:",7);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}


#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){

}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuracion();    /*llamada a funcion configuracion()*/
    lcd_init();
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Hola mundo UPC!",15);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Kalun Lau Gan",13);
    }
}

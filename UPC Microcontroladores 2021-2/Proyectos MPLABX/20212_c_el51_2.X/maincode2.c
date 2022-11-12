#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL    //frecuencia de trabajo 48MHz

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
    configuracion();
    lcd_init();
    while(1){
        unsigned int x;
        for(x=0;x<16;x++){
            ESCRIBE_MENSAJE("Hola mundo UPC!",x);
            POS_CURSOR(1,0);
            __delay_ms(150);
        }
        for(x=0;x<14;x++){
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Kalun Lau Gan",x);
            __delay_ms(150);
        }
    }
}

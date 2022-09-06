#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISBbits.RB7 = 0;      //salida al servo
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
    configuro();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Micro Semana 11",15);
    while(1){
        if(PORTBbits.RB0 == 1){
            LATBbits.LB7 = 1;
            __delay_us(2000);
            LATBbits.LB7 = 0;
            __delay_us(18000);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Servo 1: 180",12);
            ENVIA_CHAR(0xDF);
        }
        else{
            LATBbits.LB7 = 1;
            __delay_us(1000);
            LATBbits.LB7 = 0;
            __delay_us(19000);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Servo 1: 000",12);
            ENVIA_CHAR(0xDF);
        }
    }
}

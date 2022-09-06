#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void configuro(void){
    TRISBbits.RB7 = 0;
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
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Servo LS51", 10);
        if(PORTBbits.RB0 == 1){
            LATBbits.LB7 = 1;
            __delay_us(2000);       //TON
            LATBbits.LB7 = 0;
            __delay_us(18000);      //TOF
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Angulo: 180", 11);
            ENVIA_CHAR(0xDF);
        }
        else{
            LATBbits.LB7 = 1;
            __delay_us(1000);       //TON
            LATBbits.LB7 = 0;
            __delay_us(19000);      //TOF
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Angulo: 000", 11);
            ENVIA_CHAR(0xDF);
        }
    }
}

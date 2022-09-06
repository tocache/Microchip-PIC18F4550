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
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Movimiento Servo", 16);
    while(1){
        unsigned int x_var = 0;
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Servo 01: 000", 13);
        ENVIA_CHAR(0xDF);
        for(x_var=0;x_var<50;x_var++){
            LATBbits.LB7 = 1;
            __delay_us(1000);
            LATBbits.LB7 = 0;
            __delay_us(19000);
        }
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Servo 01: 090", 13);
        ENVIA_CHAR(0xDF);
        for(x_var=0;x_var<50;x_var++){
            LATBbits.LB7 = 1;
            __delay_us(1500);
            LATBbits.LB7 = 0;
            __delay_us(18500);
        }
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Servo 01: 180", 13);
        ENVIA_CHAR(0xDF);
        for(x_var=0;x_var<50;x_var++){
            LATBbits.LB7 = 1;
            __delay_us(2000);
            LATBbits.LB7 = 0;
            __delay_us(18000);
        }
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Servo 01: 090", 13);
        ENVIA_CHAR(0xDF);
        for(x_var=0;x_var<50;x_var++){
            LATBbits.LB7 = 1;
            __delay_us(1500);
            LATBbits.LB7 = 0;
            __delay_us(18500);
        }        
    }
}

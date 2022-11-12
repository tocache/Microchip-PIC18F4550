#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuro(void){
    ADCON1 = 0x0F;      //Todos en digital
    TRISEbits.RE0 = 0;  //RE0 como salida
}

void lcd_config(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    unsigned char entrada = 0;
    configuro();
    lcd_config();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE(" Servomecanismo",15);
    while(1){
        entrada = PORTB & 0x03;
        switch(entrada){
            case 0:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo: 000",11);
                ENVIA_CHAR(0xDF);
                LATEbits.LE0 = 1;
                __delay_us(1000);
                LATEbits.LE0 = 0;
                __delay_us(19000);
                break;
            case 1:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo: 045",11);
                ENVIA_CHAR(0xDF);
                LATEbits.LE0 = 1;
                __delay_us(1250);
                LATEbits.LE0 = 0;
                __delay_us(18750);
                break;
            case 2:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo: 135",11);
                ENVIA_CHAR(0xDF);
                LATEbits.LE0 = 1;
                __delay_us(1750);
                LATEbits.LE0 = 0;
                __delay_us(18250);
                break;
            case 3:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo: 180",11);
                ENVIA_CHAR(0xDF);
                LATEbits.LE0 = 1;
                __delay_us(2000);
                LATEbits.LE0 = 0;
                __delay_us(18000);
                break;
            default:
                break;
        }       
    }
}

#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    ADCON1 = 0x0F;      //Puertos E/S como digitales
    TRISEbits.RE0 = 0;  //RE0 como salida
}

void lcd_init(void){
    TRISD = 0x00;
    __delay_ms(15);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);   
}

void main(void) {
    configuracion();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Servomecanismo",14);

    while(1){
        if(PORTBbits.RB0 == 1){
            LATEbits.LE0 = 1;
            __delay_us(1750);
            LATEbits.LE0 = 0;
            __delay_us(18250);            
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Angulo:135",10);
            ENVIA_CHAR(0xDF);
        }
        else{
            LATEbits.LE0 = 1;
            __delay_us(1250);
            LATEbits.LE0 = 0;
            __delay_us(18750);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Angulo: 45",10);
            ENVIA_CHAR(0xDF);
        }
    }
}


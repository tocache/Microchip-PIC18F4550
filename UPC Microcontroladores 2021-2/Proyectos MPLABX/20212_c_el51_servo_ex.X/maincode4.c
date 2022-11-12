#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

void configuracion(void){
    ADCON1 = 0x0F;      //Puertos E/S como digitales
    TRISEbits.RE0 = 0;  //RE0 como salida
    T3CON = 0x01;       //Configuracion Timer3
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
            TMR3H = 0xA2;
            TMR3L = 0x40;           //Angulo 180° Cuenta inicial 41536
            while(PIR2bits.TMR3IF == 0);
            LATEbits.LE0 = 0;
            __delay_us(18250);            
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Angulo:180",10);
            ENVIA_CHAR(0xDF);
            PIR2bits.TMR3IF = 0;
        }
        else{
            LATEbits.LE0 = 1;
            TMR3H = 0xD1;
            TMR3L = 0x20;           //Angulo 0° Cuenta inicial 53536
            while(PIR2bits.TMR3IF == 0);
            LATEbits.LE0 = 0;
            __delay_us(18750);
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Angulo:  0",10);
            ENVIA_CHAR(0xDF);
            PIR2bits.TMR3IF = 0;
            
        }
    }
}


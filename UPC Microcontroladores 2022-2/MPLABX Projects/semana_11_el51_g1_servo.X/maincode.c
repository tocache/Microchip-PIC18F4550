#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

void configuro(void){
    OSCCON = 0x70;      //INTOSC a 8MHz
    TRISEbits.RE0 = 0;  //RE0 como salida
    ADCON1 = 0x0F;      //RE0 como digital
}

void inicializacion_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(21);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void servo_a_cero(void){
    LATEbits.LE0 = 1;
    __delay_us(700);
    LATEbits.LE0 = 0;
    __delay_us(19300);
}

void servo_a_cientoochenta(void){
    LATEbits.LE0 = 1;
    __delay_us(2300);
    LATEbits.LE0 = 0;
    __delay_us(17700);
}

void servo_a_noventa(void){
    LATEbits.LE0 = 1;
    __delay_us(1500);
    LATEbits.LE0 = 0;
    __delay_us(18500);
}


void main(void) {
    configuro();
    inicializacion_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 11 Servos", 16);
    while(1){
        unsigned char x;
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Angulo:   0", 11);
        ENVIA_CHAR(0xDF);
        for(x=0;x<50;x++){
            servo_a_cero();
        }
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Angulo:  90", 11);
        ENVIA_CHAR(0xDF);
        for(x=0;x<50;x++){
            servo_a_noventa();
        }
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Angulo: 180", 11);
        ENVIA_CHAR(0xDF);
        for(x=0;x<50;x++){
            servo_a_cientoochenta();
        }
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Angulo:  90", 11);
        ENVIA_CHAR(0xDF);
        for(x=0;x<50;x++){
            servo_a_noventa();
        }
        
    }
}
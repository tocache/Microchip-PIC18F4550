#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char indicador = 0;

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    INTCONbits.GIE = 1;
    INTCONbits.INT0E = 1;
    INTCON2bits.INTEDG0 = 0;
    INTCON2bits.RBPU = 0;
}

void inicializacion_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(19);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    inicializacion_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 11 Servos",16);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("Angulo 180",10);
    ENVIA_CHAR(0xDF);    
    while(1){
        if(indicador == 1){
            LATEbits.LE0 = 1;
            __delay_us(600);
            LATEbits.LE0 = 0;
            __delay_us(19400);
        }
        else{
            LATEbits.LE0 = 1;
            __delay_us(2300);
            LATEbits.LE0 = 0;
            __delay_us(17700);
        }
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(indicador == 1){
        indicador = 0;
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Angulo 180",10);
        ENVIA_CHAR(0xDF);
    }
    else{
        indicador = 1;
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Angulo   0",10);
        ENVIA_CHAR(0xDF);
    }
}


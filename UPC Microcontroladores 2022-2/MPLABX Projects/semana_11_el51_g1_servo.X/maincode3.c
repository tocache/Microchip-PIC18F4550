#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char indicador = 0;

void configuro(void){
    OSCCON = 0x70;      //INTOSC a 8MHz
    TRISEbits.RE0 = 0;  //RE0 como salida
    ADCON1 = 0x0F;      //RE0 como digital
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.INTEDG0 = 0;
    INTCON2bits.RBPU = 0;
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
        switch(indicador){
            case 0:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo:   0", 11);
                ENVIA_CHAR(0xDF);
                servo_a_cero();
                break;
            case 1:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo:  90", 11);
                ENVIA_CHAR(0xDF);
                servo_a_noventa();
                break;
            case 2:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo: 180", 11);
                ENVIA_CHAR(0xDF);
                servo_a_cientoochenta();
                break;
            case 3:
                POS_CURSOR(2,0);
                ESCRIBE_MENSAJE("Angulo:  90", 11);
                ENVIA_CHAR(0xDF);
                servo_a_noventa();
                break;
        }
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if (indicador == 3){
        indicador = 0;
    }
    else{
        indicador++;
    }
}
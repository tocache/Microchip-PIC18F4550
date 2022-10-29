#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char indicador = 0;

void configuro(void){
    OSCCON = 0x70;
    TRISEbits.RE0 = 0;
    ADCON1 = 0x0F;
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
}

void inicio_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(21);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    inicio_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Semana 11 servos",16);
    while(1){
        switch(indicador){
            case 0:
                LATEbits.LE0 = 1;
                __delay_us(600);
                LATEbits.LE0 = 0;
                __delay_us(19400);
                break;
            case 1:
                LATEbits.LE0 = 1;
                __delay_us(800);
                LATEbits.LE0 = 0;
                __delay_us(19200);
                break;
            case 2:
                LATEbits.LE0 = 1;
                __delay_us(1000);
                LATEbits.LE0 = 0;
                __delay_us(19000);
                break;
            case 3:
                LATEbits.LE0 = 1;
                __delay_us(1200);
                LATEbits.LE0 = 0;
                __delay_us(18800);
                break;
            case 4:
                LATEbits.LE0 = 1;
                __delay_us(1400);
                LATEbits.LE0 = 0;
                __delay_us(18600);
                break;
            case 5:
                LATEbits.LE0 = 1;
                __delay_us(1600);
                LATEbits.LE0 = 0;
                __delay_us(18400);
                break;
            case 6:
                LATEbits.LE0 = 1;
                __delay_us(1800);
                LATEbits.LE0 = 0;
                __delay_us(18200);
                break;                
            case 7:
                LATEbits.LE0 = 1;
                __delay_us(2000);
                LATEbits.LE0 = 0;
                __delay_us(18000);
                break; 
            case 8:
                LATEbits.LE0 = 1;
                __delay_us(2200);
                LATEbits.LE0 = 0;
                __delay_us(17800);
                break;
            case 9:
                LATEbits.LE0 = 1;
                __delay_us(2400);
                LATEbits.LE0 = 0;
                __delay_us(17600);
                break;  
        }
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(indicador == 9){
        indicador = 0;
    }
    else{
        indicador++;
    }
    __delay_ms(100);
}
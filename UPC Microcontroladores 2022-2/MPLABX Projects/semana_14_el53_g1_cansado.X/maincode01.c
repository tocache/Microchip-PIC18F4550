#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL
#define LUCECITA_DE_FONDO CCPR2L
#define L0_PORCIENTO 0
#define L25_PORCIENTO 31
#define L50_PORCIENTO 62
#define L75_PORCIENTO 93
#define L100_PORCIENTO 124

unsigned char estado_backlight = 0;

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    PR2 = 124;
    CCPR2L = 31;
    TRISCbits.RC1 = 0;
    T2CON = 0x07;
    CCP2CON = 0x0C;
    //LATCbits.LC1 = 1;   //temporal
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.INTEDG0 = 0;
    INTCON2bits.RBPU = 0;
}

init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(24);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Sem 14 Micro UPC");
    while(1){
        POS_CURSOR(2,0);
        ENVIA_CHAR('*');
    }
}

void __interrupt() INT0_ISR(void){
    INTCONbits.INT0IF = 0;
    if(estado_backlight == 4){
        estado_backlight = 0;
    }
    else{
        estado_backlight++;
    }
    switch(estado_backlight){
        case 0:
            LUCECITA_DE_FONDO = L0_PORCIENTO;
            break;
        case 1:
            LUCECITA_DE_FONDO = L25_PORCIENTO;
            break;
        case 2:
            LUCECITA_DE_FONDO = L50_PORCIENTO;
            break;
        case 3:
            LUCECITA_DE_FONDO = L75_PORCIENTO;
            break;
        case 4:
            LUCECITA_DE_FONDO = L100_PORCIENTO;
            break;
    }
}
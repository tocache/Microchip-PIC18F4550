#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define ENCENDIDO 1
#define APAGADO 0
#define BACKLIGHT CCPR1L
#define BANDERA_INT0 INTCONbits.INT0IF
#define B_000 0
#define B_025 31
#define B_050 62
#define B_075 93
#define B_100 124
#define _XTAL_FREQ 8000000UL

unsigned char estado_backlight = 0;

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    //LATCbits.LC2 = 1;
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.RBPU = 0;
    INTCON2bits.INTEDG0 = 0;
    PR2 = 124;
    BACKLIGHT = B_000;
    TRISCbits.RC2 = 0;
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

void init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(19);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Sem 14 Lab Micro",16);
    while(1){
        
    }
}

void __interrupt() INT0_ISR(void){
    BANDERA_INT0 = APAGADO;
    if (estado_backlight == 4){
        estado_backlight = 0;
    }
    else{
        estado_backlight++;
    }
    switch(estado_backlight){
        case 0:
            BACKLIGHT = B_000;
            break;
        case 1:
            BACKLIGHT = B_025;
            break;
        case 2:
            BACKLIGHT = B_050;
            break;
        case 3:
            BACKLIGHT = B_075;
            break;
        case 4:
            BACKLIGHT = B_100;
            break;
    }
}
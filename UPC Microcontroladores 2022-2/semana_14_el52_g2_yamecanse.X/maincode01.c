#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

unsigned char estado_backlight = 0;

void configuro(void){
    OSCCON = 0x72;
    ADCON1 = 0x0F;
    LATCbits.LC2 = 1;       //activacion temporal
    INTCONbits.GIE = 1;
    INTCONbits.INT0IE = 1;
    INTCON2bits.INTEDG0 = 0;
    INTCON2bits.RBPU = 0;
    PR2 = 62;
    CCPR1L = 15;
    TRISCbits.RC2 = 0;  
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

init_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(21);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuro();
    init_LCD();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Sem14 AUXILIO!");
    while(1){
        
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
            CCPR1L = 0;
            break;
        case 1:
            CCPR1L = 15;
            break;
        case 2:
            CCPR1L = 31;
            break;
        case 3:
            CCPR1L = 46;
            break;
        case 4:
            CCPR1L = 62;
            break;
    }
}

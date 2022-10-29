#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

void configuro(void){
    OSCCON = 0x70;
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
}

void inicio_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(22);
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
        POS_CURSOR(2,0);
        if(PORTCbits.RC1 == 1){
            ESCRIBE_MENSAJE("LDR destapado!",14);
            LATEbits.LE0 = 1;
            __delay_ms(600);
            LATEbits.LE0 = 0;
            __delay_ms(19400);
        }
        else{
            ESCRIBE_MENSAJE("LDR tapado!   ",14);
            LATEbits.LE0 = 1;
            __delay_ms(2400);
            LATEbits.LE0 = 0;
            __delay_ms(17600);
        }
    }
}

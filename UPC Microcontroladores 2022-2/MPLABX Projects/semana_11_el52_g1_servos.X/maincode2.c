#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 8000000UL

void configuro(void){
    OSCCON = 0x70;
    TRISEbits.RE0 = 0;
    ADCON1 = 0x0F;
}

void inicio_LCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(17);
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
        if(PORTCbits.RC0 == 1){
            ESCRIBE_MENSAJE("LDR destapado",13);
            LATEbits.LE0 = 1;
            __delay_us(1000);
            LATEbits.LE0 = 0;
            __delay_us(19000);
        }
        else{
            ESCRIBE_MENSAJE("LDR tapado   ",13);
            LATEbits.LE0 = 1;
            __delay_us(2000);
            LATEbits.LE0 = 0;
            __delay_us(18000);
        }
    }
}

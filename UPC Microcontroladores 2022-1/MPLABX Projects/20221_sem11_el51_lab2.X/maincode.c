#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned char centena, decena, unidad;  //variables de funcion convierte

void INIT_config(void){
    
}

void LCD_config(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void CCP1_config(void){
    PR2 = 155;
    CCPR1L = 78;
    TRISCbits.RC2 = 0;
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

void ADC_config(void){
    ADCON2 = 0x24;
    ADCON1 = 0x0D;
    ADCON0bits.ADON = 1;
}

void convierte(unsigned char numero){
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;    
}

void main(void) {
    INIT_config();
    CCP1_config();
    LCD_config();
    ADC_config();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Lab 11 Micro", 12);
    while(1){
        ADCON0 = 0x07;
        while(ADCON0bits.GODONE == 1);
        CCPR1L = ADRESH * 0.61;
        convierte(CCPR1L);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("CH1:", 4);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
    }
}

#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

//declaración de variables globales
unsigned char centena, decena, unidad;
float temp1;

void INIT_config(void){
    
}

void convierte(unsigned char numero){
    centena = (numero % 1000) / 100;
    decena = (numero % 100) / 10;
    unidad = numero % 10;    
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

void main(void) {
    INIT_config();
    CCP1_config();
    ADC_config();
    LCD_config();
    while(1){
        ADCON0 = 0x07;
        while(ADCON0bits.GODONE == 1);
        temp1 = ADRESH * 0.61;
        CCPR1L = temp1;
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Backlight:", 10);
        temp1 = ADRESH * 0.395;
        convierte(temp1);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        ENVIA_CHAR('%');        
    }
}

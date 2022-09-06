#include <xc.h>
#include "cabecera.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

//declaracion de variables globales
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
float x_var = 0;

void configuro(void){
    TRISEbits.RE0 = 0;
}

void CCP1_config(void){
    PR2 = 155;
    CCPR1L = 78;
    TRISCbits.RC2 = 0;
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

void ADC_config(void){
    ADCON2 = 0x24;      //ADFM=0 (just izq))
    ADCON1 = 0x0D;      //AN0 y AN1
    ADCON0 = 0x05;      //AN1 seleccionado, AD On
}

void TMR0_config(void){
/*    T0CON = 0x81      //Fosc/4, PSC 1:4, 16bits
    TMR0H = ¿?;
    TMR0L = ¿?;
*/ 
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void convierte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

backlight_setup(void){
    ADCON0 = 0x07;      //An1, inicio de conversion y AD on
    while(ADCON0bits.GODONE == 1);
    x_var = ADRESH * 0.61;
    CCPR1L = x_var;
    x_var = ADRESH * 0.39;
    convierte(x_var);
    POS_CURSOR(2,0);
    ESCRIBE_MENSAJE("BL:", 3);
    ENVIA_CHAR(centena + 0x30);
    ENVIA_CHAR(decena + 0x30);
    ENVIA_CHAR(unidad + 0x30);
    ENVIA_CHAR('%');
}

void main(void) {
    configuro();
    CCP1_config();
    ADC_config();
    TMR0_config();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Lab Semana 11", 13);
    while(1){
        backlight_setup();
        ADCON0 = 0x03;      //An0, inicio de conversion y AD on
        while(ADCON0bits.GODONE == 1);
        convierte(ADRESH);
        ESCRIBE_MENSAJE(" AN0:", 5);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);
        LATEbits.LE0 = 1;
        //debes de iniciar la temporizacion TON
        LATEbits.LE0 = 0;
        //debes de iniciar la temporizacion TOF
                
    }
}

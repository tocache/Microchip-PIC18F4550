#include "cabecera.h"   //ya se esta especificando la librería xc.h
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

unsigned int res_ad = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void configuro(void){
    TRISCbits.RC0 = 0;
    ADCON2 = 0xA4;
    ADCON1 = 0x0E;
    ADCON0 = 0x01;
}

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void parpadeo_RC0(void){
    LATCbits.LC0 = 1;   //RC0 en uno
    __delay_ms(100);    //Retardo 100ms
    LATCbits.LC0 = 0;   //RC0 en cero
    __delay_ms(100);    //Retardo 100ms
    LATCbits.LC0 = 1;   //RC0 en uno
    __delay_ms(100);    //Retardo 100ms
    LATCbits.LC0 = 0;   //RC0 en cero
    __delay_ms(100);    //Retardo 100ms
    LATCbits.LC0 = 1;   //RC0 en uno
    __delay_ms(100);    //Retardo 100ms
    LATCbits.LC0 = 0;   //RC0 en cero
    __delay_ms(1000);    //Retardo 100ms
}

void digbyte(unsigned int data_in){
    millar = data_in / 1000;
    centena = (data_in % 1000) /100;
    decena = (data_in % 100) / 10;
    unidad = data_in % 10;
}

void main(void) {
    configuro();
    lcd_init();
    ESCRIBE_MENSAJE("   Ejemplo 3",12);
    while(1){
        parpadeo_RC0();
        ADCON0bits.GODONE = 1;
        while(ADCON0bits.GODONE == 1);
        res_ad = (ADRESH << 8) + ADRESL;
        digbyte(res_ad);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("ADC-0:",6);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

void __interrupt() AD_ISR(void){
    
}
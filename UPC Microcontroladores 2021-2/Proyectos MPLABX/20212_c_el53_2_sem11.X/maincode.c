#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

//variables globales
unsigned int d_millar = 0;
unsigned int d_centena = 0;
unsigned int d_decena = 0;
unsigned int d_unidad = 0;
float conversion = 0;

void config_init(void){
    ADCON1 = 0x0D;      //RE0 digital, AN1 y AN0 habilitado
    TRISEbits.RE0 = 0;  //RE0 como salida
    ADCON2 = 0x24;      //ADFM=0 just izq, 8TAD FOSC/4
    ADCON0bits.ADON = 1;    //A/D encendido
    PR2 = 155;          //Periodo de PWM 4.8K
    CCPR1L = 77;        //Duty Cycle 50%
    TRISCbits.RC2 = 0;
    T2CON = 0x07;
    CCP1CON = 0x0C;
}

void lcd_init(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);    
}

void digbyte(unsigned int dato){
    d_millar = dato / 1000;
    d_centena = (dato % 1000) / 100;
    d_decena = (dato % 100) / 10;
    d_unidad = dato % 10;
}

void main(void) {
    unsigned int ad_an1 = 0;
    config_init();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Micro Sem 11 UPC",16);
    while(1){
        ADCON0 = 0x07;      //Tomo muestra en AN1
        while(ADCON0bits.GODONE == 1);
        conversion = ADRESH * 0.61;
        CCPR1L = conversion;
        //CCPR1L = ADRESH;
        //CCP1CONbits.DC1B1 = (ADRESL >> 7) & 0x01;
        //CCP1CONbits.DC1B0 = (ADRESL >> 6) & 0x01;
        ad_an1 = (((ADRESH << 8) + ADRESL ) >> 6) & 0x03FF; //ADFM=0
        //ad_an1 = (ADRESH << 8) + ADRESL;    //si ADFM=1
        digbyte(ad_an1);
        POS_CURSOR(2,0);
        ENVIA_CHAR(d_millar + 0x30);
        ENVIA_CHAR(d_centena + 0x30);
        ENVIA_CHAR(d_decena + 0x30);
        ENVIA_CHAR(d_unidad + 0x30);
    }
}

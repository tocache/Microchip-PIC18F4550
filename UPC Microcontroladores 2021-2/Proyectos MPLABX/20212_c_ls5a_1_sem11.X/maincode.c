#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

//variables globales
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
float calculo = 0;

void init_conf(void){
    //TRISCbits.RC2 = 0;  //RC2 como salida
    //LATCbits.LC2 = 1;   //RC2 = 1, accionamiento manual del backlight
    ADCON2 = 0x24;      //ADFM=0, 8TAD, FOSC/4
    ADCON1 = 0x0D;      //AN1, AN0 habilitados
    ADCON0bits.ADON = 1;//conversor A/D encendido
    PR2 = 155;          //Periodo de PWM
    CCPR1L = 77;        //Duty Cycle inicial: 50%
    TRISCbits.RC2 = 0;  //RC2 como salida para CCP1
    T2CON = 0x07;       //Configuracion de Timer2
    CCP1CON = 0x0C;     //Configuracion del CCP en modo PWM
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

void digbyte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    unsigned int res_ad_an1 = 0;
    init_conf();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE(" Lab Sem 11 UPC", 15);
    while(1){
        ADCON0 = 0x07;      //Tomo muestra de AN1
        while(ADCON0bits.GODONE == 1);
        res_ad_an1 = (((ADRESH << 8) + ADRESL) >> 6) & 0x03FF;
        calculo = ADRESH * 0.61;        //escalamiento
        CCPR1L = calculo;
        digbyte(res_ad_an1);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("AN1:", 4);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
}

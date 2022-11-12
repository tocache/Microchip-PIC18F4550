#include "cabecera.h"
#include "LCD.h"
#include <xc.h>
#define _XTAL_FREQ 48000000UL

//declaracion de variables globales
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
float escalamiento = 0;

void lcd_init(void){
    TRISD = 0x00;
    __delay_ms(50);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}  

void init_conf(void){
    TRISCbits.RC2 = 0;      //RC2 salida
    //LATCbits.LC2 = 1;       //RC2=1
    ADCON2 = 0x24;          //ADFM=0, 8TAD, FOSC/4
    ADCON1 = 0x0D;          //AN0 y AN1 habilitados
    ADCON0bits.ADON = 1;    //Conv A/D encendido
    PR2 = 155;              //Periodo (f=4.8K)
    CCPR1L = 77;            //Duty cycle 50%)
    T2CON = 0x07;           //Configurar el Timer2
    CCP1CON = 0x0C;         //Modo PWM del CCP1
}

void convierte(unsigned int numero){
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void) {
    unsigned int res_ad_ch1 = 0;
    init_conf();
    lcd_init();
    POS_CURSOR(1,0);
    ESCRIBE_MENSAJE("Lab-11 Micro UPC", 16);
    while(1){
        ADCON0 = 0x07;      //Obtencion de muestra en AN1
        while(ADCON0bits.GODONE == 1);
        escalamiento = ADRESH * 0.61;
        CCPR1L = escalamiento;
        res_ad_ch1 = (((ADRESH << 8) + ADRESL) >> 6) & 0x03FF;
        convierte(res_ad_ch1);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("AN1:", 4);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);        
    }
}

/* Detalle de los bits de configuracion*/

#pragma config PLLDIV = 1 // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly)) 
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2]) 
#pragma config FOSC = XTPLL_XT // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL)) 
#pragma config PWRT = ON // Power-up Timer Enable bit (PWRT enabled) 
#pragma config BOR = OFF // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software) 
#pragma config WDT = OFF // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
#pragma config CCP2MX = ON // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1) 
#pragma config PBADEN = OFF // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset) 
#pragma config MCLRE = ON // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled) 
#pragma config LVP = OFF // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled) 

#include <xc.h>
#include "ADC.h"
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

int resul = 0;
int digmil = 0;
int digcen = 0;
int digdec = 0;
int diguni = 0;
int temporal = 0;
int temporal2 = 0;

void main(void) {
    TRISD = 0x00;
    ADC_CONFIG(0);      //Configuramos el RA0 como AN0 para ser usado por el ADC
    LCD_CONFIG();       //Configuracion inicial para usar el LCD
    __delay_ms(10);
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);  //Apagamos el cursor en el LCD
    CURSOR_HOME();      //Movemos el cursor al inicio del LCD (pos 0,0)
    ESCRIBE_MENSAJE("ADCMON:", 7);
    while(1){
        resul = ADC_CONVERTIR();
        //resul = resul >> 2;
        conviertemon();
        POS_CURSOR(1,8);
        ENVIA_CHAR(digmil+0x30);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
        __delay_ms(50);
    }
}

conviertemon(){
        digmil = resul / 1000;
        temporal = resul - (digmil * 1000);
        digcen = temporal / 100;
        temporal2 = temporal - (digcen * 100);
        digdec = temporal2 / 10;
        diguni = temporal2 - (digdec * 10);
}
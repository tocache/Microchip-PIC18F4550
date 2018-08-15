#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XT_XT  // Oscillator Selection bits (XT oscillator, PLL disabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#define _XTAL_FREQ 4000000UL

#include <xc.h>
#include "ADC.h"
#include "LCD.h"

int resultado = 0;
char digcen;
char digdec;
char diguni;
char temporal;



void main(void) {
    arranca_LCD();
    ADC_CONFIG(0);
    ADCON2bits.ADFM = 0;
    while(1){
        CURSOR_HOME();    //Cursor en la posición 0,0
        ESCRIBE_MENSAJE("Lectura del Pot", 15);
        resultado = ADC_CONVERTIR();
        temporal = resultado; 
        conviertemon();
        POS_CURSOR(2,2);    //Cursos en la posición 2,0
        ESCRIBE_MENSAJE("Valor:", 6);
        ENVIA_CHAR(digcen+0x30);
        ENVIA_CHAR(digdec+0x30);
        ENVIA_CHAR(diguni+0x30);
    }
}

arranca_LCD(){
    TRISD = 0x00;           //PUERTO D TODOS COMO SALIDA
    LCD_CONFIG();           //INSTRUCCIONES PARA 
    __delay_ms(10);         //INICIALIZAR EL
    BORRAR_LCD();           //MODULO LCD 2X20
    CURSOR_ONOFF(OFF);      //HITACHI 44780
}

conviertemon(){
        digcen = ADRESH / 100;
        temporal = ADRESH - (digcen * 100);
        digdec = temporal / 10;
        diguni = temporal - (digdec * 10);
}
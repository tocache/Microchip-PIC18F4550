#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

//Declaracion de variables globales
unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
unsigned int cuenta = 0;

unsigned int resultado = 0;
unsigned int res_v = 0;
unsigned int res_ohm = 0;


void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void init_conf(void){
    //Configuración del ADC
    ADCON2 = 0xA4;
    ADCON1 = 0x0e;      //solo AN0
    ADCON0 = 0x01;      //ADC on
}

void convierte(unsigned int numero){
    d_millar = numero / 10000;
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void main(void){
    init_conf();
    lcd_init();
    ESCRIBE_MENSAJE("Lectura ADC", 11);
    while(1){
        ADCON0bits.GODONE = 1;                  //Inicia la conversión
        while(ADCON0bits.GODONE == 1);
        resultado = (ADRESH << 8) + ADRESL;
        convierte(resultado);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("Canal 0:   ",11);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        POS_CURSOR(3,0);
        ESCRIBE_MENSAJE("Voltaje 0:",10);
        res_v = resultado * 5;
        convierte(res_v);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR('.');
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(' ');
        ENVIA_CHAR('V');
        POS_CURSOR(4,0);
        ESCRIBE_MENSAJE("Resist 0: ",10);
        res_ohm = resultado * 10;
        convierte(res_ohm);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR('.');
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
        ENVIA_CHAR(' ');
        ENVIA_CHAR('K');
        ENVIA_CHAR(0xF4);
    }
}    
    
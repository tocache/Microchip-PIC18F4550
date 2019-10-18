//Este es un comentario
//Bits de configuracion o directivas de preprocesador
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC2_PLL3// System Clock Postscaler Selection bits ([Primary Oscillator Src: /2][96 MHz PLL Src: /3])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 32000000UL   //Frecuencia de trabajo actual

unsigned int canal_cero = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void convierte(unsigned int numero){
    millar = numero / 1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void arrancaLCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    CURSOR_HOME();
}

void main(void){
    arrancaLCD();
    ADCON2 = 0x91;  //FOsc/8 4TAD justificacion derecha
    ADCON1 = 0x0E;  //Canal AN0 habilitado
    ADCON0 = 0x01;  //Encendemos el A/D
    ESCRIBE_MENSAJE("Lectura A/D", 11);
    while(1){
        ADCON0bits.GO = 1;
        while(ADCON0bits.GO == 1);
        canal_cero = ADRESH << 8;
        canal_cero = canal_cero + ADRESL;
        convierte(canal_cero);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("AN0: ", 5);
        ENVIA_CHAR(millar+0x30);
        ENVIA_CHAR(centena+0x30);
        ENVIA_CHAR(decena+0x30);
        ENVIA_CHAR(unidad+0x30);
    }
            
}
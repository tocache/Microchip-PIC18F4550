// Definicion de los bits de configuraci�n
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
#define _XTAL_FREQ 48000000UL    // Definimos frecuencia para la libreria XC

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    lcd_init();
    while (1){
        BORRAR_LCD();
        POS_CURSOR(1,2);
        ESCRIBE_MENSAJE("hola mundo",10);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("microcontrolador",16);
        __delay_ms(2000);
        BORRAR_LCD();
        POS_CURSOR(1,3);
        ESCRIBE_MENSAJE("Kalun Jose",10);
        POS_CURSOR(2,4);
        ESCRIBE_MENSAJE("Lau Gan",7);
        __delay_ms(2000);        
    }
    return;
}
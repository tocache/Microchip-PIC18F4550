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

#define _XTAL_FREQ 48000000UL

void main(void) {
    TRISD = 0x00;
    while(1){
        if (PORTBbits.RB0 == 1){
            LATD = 0x01;
            __delay_ms(100);
            LATD = 0x02;
            __delay_ms(100);
            LATD = 0x04;
            __delay_ms(100);
            LATD = 0x08;
            __delay_ms(100);
            LATD = 0x10;
            __delay_ms(100);
            LATD = 0x20;
            __delay_ms(100);
            LATD = 0x40;
            __delay_ms(100);
            LATD = 0x80;
            __delay_ms(100);
            LATD = 0x40;
            __delay_ms(100);
            LATD = 0x20;
            __delay_ms(100);
            LATD = 0x10;
            __delay_ms(100);
            LATD = 0x08;
            __delay_ms(100);
            LATD = 0x04;
            __delay_ms(100);
            LATD = 0x02;
            __delay_ms(100);
        }
        else{
            LATD = 0x81;
            __delay_ms(100);
            LATD = 0x42;
            __delay_ms(100);
            LATD = 0x18;
            __delay_ms(100);
            LATD = 0x42;
            __delay_ms(100);
        }
    }
}

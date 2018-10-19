

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

#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo

void main(void) {
    TRISD = 0xFE;
    T0CON = 0xC0;       //Timer0 ON, PSC 1:2, FOSC/4
    INTCON = 0XA0;      //GIE ON, T0IE ON
    while(1){
        return;
    }
}

void __interrupt(high_priority) Tmr0ISR(void){
    if (PORTDbits.RD0 == 1){
        LATDbits.LD0 = 0;
    }
    else{
        LATDbits.LD0 = 1;
    }
    TMR0L = 6;
    INTCONbits.T0IF = 0;
}

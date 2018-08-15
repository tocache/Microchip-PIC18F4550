/*Mi segundo programa, parpadeo de un LED*/

#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = ON      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>

#define _XTAL_FREQ 48000000UL

char tblsup[] = {0xE3, 0xCF, 0xE3, 0x3F, 0x00};
char tblinf[] = {0x11, 0x01, 0x18, 0x00, 0x00};

void main(void) {
    TRISD = 0x00;
    TRISB = 0x00;
    TRISC = 0xFC;
    while(1){
        LATCbits.LC0 = 0;
        LATCbits.LC1 = 0;
        paolo();
    }
}

paolo(){
    for (int i=0;i<5;i++){
        LATB = tblsup[i];
        LATD = tblinf[i];
        __delay_ms(1000);
    }
}


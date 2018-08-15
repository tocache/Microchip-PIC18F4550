/*Mi segundo programa, parpadeo de un LED*/

#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = INTOSCIO_EC  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config MCLRE = OFF       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>

#define _XTAL_FREQ 8000000UL


void main(void) {
    TRISBbits.RB0 = 0; /*Puerto D0 como salida*/
    OSCCON = 0x70;
        while(1)    {
            LATBbits.LB0 = 1;
            __delay_ms(80);
            LATBbits.LB0 = 0;
            __delay_ms(150);
            LATBbits.LB0 = 1;
            __delay_ms(80);
            LATBbits.LB0 = 0;
            __delay_ms(1000);
        }
}

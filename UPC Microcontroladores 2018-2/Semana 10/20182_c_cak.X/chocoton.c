
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])

#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>

#define _XTAL_FREQ 48000000UL //Para que el XC8 sepa la frecuencia de trabajo
/*este es un comentario*/


void main(void) {
    //TRISB = 0xFE;
    TRISBbits.RB0 = 0;
    ADCON1 = 0xFF;
    while(1){
        if (PORTEbits.RE0 == 1){
            LATBbits.LB0 = 1;
            //__delay_ms(1);
            __delay_us(900);
            LATBbits.LB0 = 0;
            __delay_ms(19);
            __delay_us(100);
        }
        else{
            LATBbits.LB0 = 1;
            __delay_ms(3);
            __delay_us(100);
            LATBbits.LB0 = 0;
            __delay_ms(16);
            __delay_us(900);
        }
    }
}
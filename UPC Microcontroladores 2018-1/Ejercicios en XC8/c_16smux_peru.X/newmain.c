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

char tblsup[] = {0x00, 0x00, 0xE3, 0xCF, 0xE3, 0x3F, 0x00, 0x00};
char tblinf[] = {0x00, 0x00, 0x11, 0x01, 0x18, 0x00, 0x00, 0x00};
char cuenta=0;

void main(void) {
    TRISD = 0x00;
    TRISB = 0x00;
    TRISC = 0xFC;
    //Tengo que establecer la configuración de la interrrupción del Timer0
    T0CON = 0xC7; //Timer0 ON, 1:256PSC, FOsc/4
    INTCON = 0xA0; //Interrupción habilitada para Timer0
//    INTCONbits.GIE = 1;
//    INTCONbits.T0IE = 1;
    while(1){
        cuenta = cuenta + 1;
        if (cuenta == 8){
            cuenta = 0;
        }
        __delay_ms(1000);
    }
}

void interrupt pizarro(void){
    if (TMR0IE && TMR0IF) {
        TMR0IF=0;
        LATB = tblsup[cuenta];
        LATD = tblinf[cuenta];
        LATCbits.LC0 = 0;
        LATCbits.LC1 = 1;
        __delay_ms(5);
        LATB = tblsup[cuenta+1];
        LATD = tblinf[cuenta+1];
        LATCbits.LC0 = 1;
        LATCbits.LC1 = 0;
        __delay_ms(5);
        LATCbits.LC0 = 1;
        LATCbits.LC1 = 1;
        return;
    }
}



/*Mi segundo programa, parpadeo de un LED*/

#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>

#define _XTAL_FREQ 48000000UL

char tablota[] = 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x40, 0x20,
                 0x10, 0x08, 0x04, 0x02;
char tablota2[] = 0x81, 0x42, 0x24, 0x18, 0x24, 0x42;
char i = 0;

void main(void) {
    TRISD = 0x00;           /*Puerto D como salida*/
    TRISBbits.RB0 = 1;      /*Forzando al B0 como entrada*/
    TRISBbits.RB6 = 1;      /*Forzando al B6 como entrada*/    
        while(1)    {
            if (PORTBbits.RB6 == 1){
                for (i=0;i<14;i++)   {
                    LATD = tablota[i];
                    if (PORTBbits.RB0 == 1)  {
                        __delay_ms(100);
                    }
                    else    {
                        __delay_ms(500);
                    }
                }}
            else{
                for (i=0;i<6;i++)   {
                    LATD = tablota2[i];
                    if (PORTBbits.RB0 == 1)  {
                        __delay_ms(100);
                    }
                    else    {
                        __delay_ms(500);
                    }
                }
            }
        }
}

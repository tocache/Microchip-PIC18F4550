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

#define _XTAL_FREQ 48000000UL   //Frecuencia del oscilador del CPU (48MHz)

char papanatas1[] = {0x88,0x8C,0xAF,0xA3,0x83,0x88,0xA1,0xA3,0xFF};
                     /*A    P    R    O    B    A    D    O*/
char papanatas2[] = {0xA1,0x86,0x92,0x88,0x8C,0xAF,0xA3,0x83,0x88,0xA1,0xA3,0xFF};
                     /*D    E    S    A    P    R    O    B    A    D    O*/

void main(void) {
    TRISB = 0x80;   /*Puerto B6 al B0 como salidas*/
    TRISCbits.RC0 = 1;  /*Puerto C0 como entrada*/
    while(1){
        if (PORTCbits.RC0 == 1){
            for (char i=0;i<9;i++){
                LATB = papanatas1[i];
                __delay_ms(300);}           
        }
        else{
            for (char i=0;i<12;i++){
                LATB = papanatas2[i];
                __delay_ms(300);}           
        }
    }
}
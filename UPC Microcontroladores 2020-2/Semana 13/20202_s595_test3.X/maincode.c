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
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

void init_config(void){
    TRISE = 0x00;           //Todo RE como salida
}

void envio_595(unsigned char datain){
    int i=0;
    LATEbits.LE1 = 0;
    LATEbits.LE0 = 0;
    LATEbits.LE2 = 0;    
    for (i=7; i>=0; i--)    {
        LATEbits.LE1 = 0;
        if (datain &(1<<i))    {
            LATEbits.LE0 = 1;
        }
        else{
            LATEbits.LE0 = 0;
        }
        LATEbits.LE1 = 1;
        LATEbits.LE0 = 0;
    }
    LATEbits.LE2 = 1;
    LATEbits.LE1 = 0;    
}

void main(void){
    init_config();
    while(1){
        envio_595('U');
        __delay_ms(500);
        envio_595('P');
        __delay_ms(500);        
        envio_595('C');
        __delay_ms(500);
    }
}
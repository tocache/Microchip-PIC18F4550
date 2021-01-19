#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <stdio.h>
#include <stdlib.h>
//#include <stdint.h>
#include <xc.h>

#define _XTAL_FREQ 48000000UL

#define RELOJ LATEbits.LE1      //Definición de etiquetas para los pines
#define DATO LATEbits.LE0
#define LATCHEO LATEbits.LE2

void S595_config(void)    {
    ADCON1 = 0x0F;              //Para que sean digitales...
    TRISEbits.RE0 = 0;
    TRISEbits.RE1 = 0;
    TRISEbits.RE2 = 0;
    RELOJ = 0;
    DATO = 0;
    LATCHEO = 0;
} 

void S595_dataout(int dataout) {
    int i=0;
    unsigned char pinstate=0;
    RELOJ = 0;
    DATO = 0;
    LATCHEO = 0;    
    for (i=7; i>=0; i--)    {
        RELOJ = 0;
        if (dataout &(1<<i))    {
            pinstate = 1;
        }
        else{
            pinstate = 0;
        }
        DATO = pinstate;
        RELOJ = 1;
        DATO = 0;
    }
    LATCHEO = 1;
    RELOJ = 0;
}

void main(void) {
    S595_config();
    while(1){
        S595_dataout('U');
        __delay_ms(500);
        S595_dataout('P');
        __delay_ms(500);
        S595_dataout('C');
        __delay_ms(500);
    }
}



//Esta es la nueva plantilla para programas en XC8
//Para el microcontrolador PIC18F4550

#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo

char estado = 0;

void main(void) {
    TRISD = 0xFC;               //Puerto RD0 y RD1 como salida
    INTCONbits.GIE = 1;         //Interruptor global de interrupciones activada
    INTCONbits.INT0IE = 1;       //Interruptor de interrupcion externa 0
    while(1){
        switch (estado){
            case 4 :
                LATDbits.LD0 = 1;
                __delay_us(100);
                LATDbits.LD0 = 0;
                __delay_us(900);
                LATDbits.LD1 = 1;
                break;
            case 3 :
                LATDbits.LD0 = 1;
                LATDbits.LD1 = 1;
                break;
            case 2 :
                LATDbits.LD0 = 1;
                LATDbits.LD1 = 0;
                __delay_ms(100);
                LATDbits.LD0 = 0;
                LATDbits.LD1 = 1;
                __delay_ms(100);
                break;
            case 1 :
                LATDbits.LD0 = 1;
                LATDbits.LD1 = 0;
                __delay_ms(200);
                LATDbits.LD0 = 0;
                LATDbits.LD1 = 1;
                __delay_ms(200);
                break;
            case 0 :
                LATDbits.LD0 = 0;
                LATDbits.LD1 = 0;
                break;
        }
    }
}

void __interrupt (high_priority) Int0ISR(void){
    __delay_ms(100);
    if (estado == 4){
        estado = 0;
    }
    else{
        estado++;
    }
    INTCONbits.INT0IF = 0;
}

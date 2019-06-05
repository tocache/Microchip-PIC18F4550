    
#pragma config PLLDIV = 1 // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly)) 
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2]) 
#pragma config FOSC = XTPLL_XT // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL)) 
#pragma config PWRT = ON // Power-up Timer Enable bit (PWRT enabled) 
#pragma config BOR = OFF // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software) 
#pragma config WDT = OFF // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
#pragma config CCP2MX = ON // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1) 
#pragma config PBADEN = OFF // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset) 
#pragma config MCLRE = ON // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled) 
#pragma config LVP = OFF // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled) 

#include <xc.h>
#define _XTAL_FREQ 48000000UL

typedef union {
    uint24_t byte;
    struct {
        unsigned pa0 :1;
        unsigned pa1 :1;
        unsigned pa2 :1;
        unsigned pa3 :1;
        unsigned pa4 :1;
        unsigned pa5 :1;
        unsigned pa6 :1;
        unsigned pa7 :1;
    };
} byte_t;
byte_t papanatas;

uint24_t lechugotas;
#define lechugotas_bit (*(byte_t *)&lechugotas)

void main(void) {
    TRISBbits.RB0 = 0;
    ;TRISB = 0xFE;
    while(1){
        papanatas.pa0 = 0;
        LATBbits.LB0 = papanatas.pa2;
        lechugotas_bit.pa0 = 0;
        lechugotas = 0xFF;
        __delay_ms(100);
    }
}
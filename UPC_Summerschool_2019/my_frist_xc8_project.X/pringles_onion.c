//This is a comment
/*This is another comment*/

// PIC18F4550 Configuration Bit Settings

// 'C' source line config statements
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>

#define _XTAL_FREQ 48000000UL   //Main frequency obtained from PLL module

int angle = 0;                  //global variable for angle

void main(void){
   TRISDbits.TRISD0 = 0;
   INTCONbits.GIE = 1;
   INTCONbits.INT0IE = 1;       //INT0 ISR enabled
   while(1){
       if(angle == 0){
           LATDbits.LATD0 = 1;
           __delay_us(1000);
           LATDbits.LATD0 = 0;
           __delay_ms(19);
       }
       else if (angle == 1){
       LATDbits.LATD0 = 1;
       __delay_us(1500);
       LATDbits.LATD0 = 0;
       __delay_ms(18);
       __delay_us(500);
       }
       else if (angle == 2){
       LATDbits.LATD0 = 1;
       __delay_us(2000);
       LATDbits.LATD0 = 0;
       __delay_ms(18);
       }
       else{
       LATDbits.LATD0 = 1;
       __delay_us(1500);
       LATDbits.LATD0 = 0;
       __delay_ms(18);
       __delay_us(500);
       }
   }
}

void __interrupt (high_priority) INT0ISR(void){
    if (angle == 3){
        angle = 0;
    }
    else{
        angle = angle + 1;
    }
    INTCONbits.INT0IF = 0;
}

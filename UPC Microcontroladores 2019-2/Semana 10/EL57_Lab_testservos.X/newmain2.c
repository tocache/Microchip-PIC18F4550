//Este es un comentario
//Bits de configuracion o directivas de preprocesador
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC2_PLL3// System Clock Postscaler Selection bits ([Primary Oscillator Src: /2][96 MHz PLL Src: /3])
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
#define _XTAL_FREQ 32000000UL   //Frecuencia de trabajo actual

unsigned int tiempo = 0;
unsigned char estado = 0;
unsigned int temporal = 0;
unsigned int temporal_on = 0;
unsigned int temporal_off = 0;
unsigned int TMR0H_on = 0;
unsigned int TMR0L_on = 0;
unsigned int TMR0H_off = 0;
unsigned int TMR0L_off = 0;

void ingresoTmr0(unsigned int tiempo){
    T0CONbits.TMR0ON = 1;
    temporal =
    
//    temporal = (65535 - tiempo) & 0x00FF;
//    TMR0L = temporal;
//    temporal = (65535 - tiempo) >> 8;
//    TMR0H = temporal;
}

void main(void){
    ADCON1 = 0x0F;              //Todos los RXy en digitales
    TRISEbits.RE0 = 0;
    T0CON = 0x82;               //TMR0 OFF, FOsc/4, PS 1:8
    INTCONbits.GIE = 1;
    INTCONbits.TMR0IE = 1;
    while(1){
        while(PORTBbits.RB0 == 1){
            ingresoTmr0(1000);
        }
        while(PORTBbits.RB1 == 1){
            ingresoTmr0(1500);
        }
        while(PORTBbits.RB2 == 1){
            ingresoTmr0(2000);
        }
        T0CONbits.TMR0ON = 0;
        LATEbits.LE0 = 0;
    }    
}

void __interrupt (high_priority) Tmr0ISR(void){
    if(estado == 0){
        estado = 1;
        LATEbits.LE0 = 0;
//        TMR0L = 0x17;
//        TMR0H = 0xFC;
        TMR0L = 0x2E;
        TMR0H = 0xF8;
                
    }
    else{
        estado = 0;
        LATEbits.LE0 = 1;
//        TMR0L = 0xC7;
//        TMR0H = 0xB5;
        TMR0L = 0xAE;
        TMR0H = 0xB9;
    }
    INTCONbits.T0IF = 0;
}
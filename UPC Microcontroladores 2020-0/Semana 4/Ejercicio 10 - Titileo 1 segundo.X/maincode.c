// PIC18F4550 Configuration Bit Settings
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#define _XTAL_FREQ 4000000UL
#include <xc.h>

void main(void) {
    TRISDbits.RD0 = 0;       //RD0 output
    T1CON = 0x8B;           //TMR1 ON, fosc/4 source, psc 1:4
    CCP1CON = 0x0B;         //CCP1 compare mode trigger special event
    CCPR1H = 0x80;          //Valor de comparación
    CCPR1L = 0x00;
    INTCON = 0xC0;          //Global interrupt enabled, peripherial interrupt enabled
    PIE1bits.CCP1IE = 1;    //CCP1 interrupt enabled
    while(1){
        __delay_us(1);
    }
}

void __interrupt() CCP1ISR(void){
    if(PORTDbits.RD0 == 1){
        LATDbits.LD0 = 0;
    }
    else{
        LATDbits.LD0 = 1;
    }
    PIR1bits.CCP1IF = 0;
}
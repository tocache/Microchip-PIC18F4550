// PIC18F4550 Configuration Bit Settings
#pragma config FOSC = XT_XT     // Oscillator Selection bits (XT oscillator (XT))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#define _XTAL_FREQ 4000000UL
#include <xc.h>

void main(void){
    PR2 = 249;          //Periodo del PWM (supuestamente 1KHz)
    CCPR1L = 63;       //Duty Cycle del PWM 25%)
    TRISCbits.RC2 = 0;  //Puerto RC2 CCP1 como salida
    T2CON = 0x05;       //Encendemos el Timer 2 y con PSC 1:4
    CCP1CON = 0x0C;     //CCP1 en modo PWM
    while(1){
        __delay_us(10);
    }
}
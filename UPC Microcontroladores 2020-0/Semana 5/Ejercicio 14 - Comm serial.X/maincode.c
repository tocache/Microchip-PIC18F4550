//Este es un comentario
//Bits de configuracion o directivas de preprocesador
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /2][96 MHz PLL Src: /3])
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

#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo actual
#include <xc.h>

void main(void){
    TXSTAbits.BRGH = 0;
    TXSTAbits.SYNC = 0;
    BAUDCONbits.BRG16 = 0;          //Configuracion para usar FOSC/64(n+1))
    SPBRG = 77;                     //9600 baudios
    RCSTAbits.SPEN = 1;             //Encendemos el puerto serial
    TXSTAbits.TXEN = 1;             //Habilitamos el transmisor
    while(1){
        if (PORTBbits.RB0 == 1){
            TXREG = 'H';
            while(TXSTAbits.TRMT == 0);
            TXREG = 'o';
            while(TXSTAbits.TRMT == 0);
            TXREG = 'l';
            while(TXSTAbits.TRMT == 0);
            TXREG = 'a';
            while(TXSTAbits.TRMT == 0);
            TXREG = 0x0A;
            while(TXSTAbits.TRMT == 0);
            TXREG = 0x0D;
            while(TXSTAbits.TRMT == 0);
        }
        if (PORTBbits.RB1 == 1){
            TXREG = 'm';
            while(TXSTAbits.TRMT == 0);
            TXREG = 'u';
            while(TXSTAbits.TRMT == 0);
            TXREG = 'n';
            while(TXSTAbits.TRMT == 0);
            TXREG = 'd';
            while(TXSTAbits.TRMT == 0);    
            TXREG = 'o';
            while(TXSTAbits.TRMT == 0);    
            TXREG = 0x0A;
            while(TXSTAbits.TRMT == 0);
            TXREG = 0x0D;
            while(TXSTAbits.TRMT == 0);
        }
        __delay_ms(500);
    }
    
}
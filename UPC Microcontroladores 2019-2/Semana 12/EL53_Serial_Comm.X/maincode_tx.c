//Este es un comentario
/*Este es otro comentario*/

// PIC18F4550 Configuration Bit Settings
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
#define _XTAL_FREQ 32000000UL   // Frecuencia de trabajo del microcontrolador

unsigned char cadena[] = {"Electronica - Mecatronica"};

void main(void){
    //Para configurar la velocidad a 9600 con 32MHz
    BAUDCONbits.BRG16 = 0;
    TXSTAbits.SYNC = 0;
    TXSTAbits.BRGH = 0;
    SPBRGH = 0;
    SPBRG = 51;
    TXSTAbits.TXEN = 1;     //Habilitamos la tranmisión en el EUSART
    RCSTAbits.SPEN = 1;         //Encendemos el EUSART
    TRISCbits.RC6 = 0;
    while(1){
        TXREG = 'u';
        while(TXSTAbits.TRMT == 0);
        TXREG = 'p';
        while(TXSTAbits.TRMT == 0);
        TXREG = 'c';
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;
        while(TXSTAbits.TRMT == 0);
        for(unsigned char i=0;i<25;i++){
            TXREG = cadena[i];
            while(TXSTAbits.TRMT == 0);
        }
        TXREG = 0x0A;
        while(TXSTAbits.TRMT == 0);
        TXREG = 0x0D;        
        while(TXSTAbits.TRMT == 0);
        __delay_ms(1000);
    }
}
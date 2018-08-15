#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XT_XT  // Oscillator Selection bits (XT oscillator, PLL disabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF      // PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#define _XTAL_FREQ 4000000UL

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <xc.h>

char cadenon[] = {"Mañana hay simulacro de sismo, hay que correr rapido$"};
char i = 0;

void main(void) {
    configCOM();
    TRISDbits.RD0 = 0;
    while(1){
        while(cadenon[i] != '$'){
            TXREG = cadenon[i];
            __delay_ms(1);
            i++;
        }
        i = 0;
        TXREG = 0x0A;
        __delay_ms(1);
        TXREG = 0x0D;
        __delay_ms(101);
        if(PIR1bits.RCIF ==1){
            if(RCREG == '1'){
                LATDbits.LD0 = 1;
            }
            if(RCREG =='0'){
                LATDbits.LD0 = 0;
            }
            PIR1bits.RCIF = 0;
        }
    }
}

configCOM(){
    SPBRGH = 0;
    SPBRG = 25;
    TXSTAbits.BRGH = 1;
    BAUDCONbits.BRG16 = 0;
    TXSTAbits.SYNC = 0;
    RCSTAbits.SPEN = 1;
    RCSTAbits.CREN = 1;
    TXSTAbits.TXEN = 1;
    TRISCbits.RC6 = 0;
}
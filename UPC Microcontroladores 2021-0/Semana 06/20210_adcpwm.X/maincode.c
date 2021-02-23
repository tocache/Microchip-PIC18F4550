#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC4_PLL6// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = OFF      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#define _XTAL_FREQ 16000000UL       //frecuencia de trabajo

unsigned int res_ad = 0;

void init_config(void){
    PR2 = 249;          //PWMfreq=1KHz
    CCPR2L = 125;       //PWMdc=50%  
    //TRISCbits.RC1 = 0; //CCP2MX = ON
    TRISBbits.RB3 = 0;  //CCP2MX = OFF 
    T2CON = 0x06;       //PSC1:16
    CCP2CON = 0x0C;     //PWM mode
    ADCON2 = 0x24;      // tiempo de conversion ADFM = 0 just izq
    ADCON1 = 0x0E;      //AN0 como anbalógico
    ADCON0 = 0x01;      //Activar A/D
}

void main(void){
    init_config();
    while(1){
        ADCON0bits.GODONE = 1;
        while(ADCON0bits.GODONE == 1);
        CCPR2L = ADRESH;
        if(PORTBbits.RB0 == 1){
            CCP2CON = 0x0C; //CCP2 PWM
        }
        else{
            CCP2CON = 0x00; //CCP2 OFF
        }
    }
}

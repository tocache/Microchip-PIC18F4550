
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])

#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "ADC.h"

#define _XTAL_FREQ 48000000UL //Para que el XC8 sepa la frecuencia de trabajo
/*este es un comentario*/

int periodon = 0;
int resul = 0;
float temporal = 0;
float factormon = 2.15;
//int i = 0;
//int j = 0;

void main(void) {
    //TRISB = 0xFE;
    ADC_CONFIG(0);
    TRISBbits.RB0 = 0;
    while(1){
        resul = ADC_CONVERTIR();
        temporal = resul * factormon;
        temporal = temporal + 900;
        periodon = temporal;
        servomon();
//        if (resul == 0){
//            periodon = 900;
//            servomon();
//        }
//        else{
//            periodon = 3100;
//            servomon();
        
    }
}

servomon(){
    LATBbits.LB0 = 1;
    for(int i=0;i<periodon-650;i++){
        __delay_us(1);
    }
    LATBbits.LB0 = 0;
    for(int i=0;i<20000-periodon;i++){
        __delay_us(1);
    }
}
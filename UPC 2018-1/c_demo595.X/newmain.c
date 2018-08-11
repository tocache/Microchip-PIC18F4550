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

#define reloj LATDbits.LD0
#define datapin LATDbits.LD1
#define latch LATDbits.LD2

unsigned char data595 = 0x26;
unsigned char data595_a = 0x51;


void main(void){
    configuracion();
    while(1){
        out595();
        __delay_ms(1);
    }
}

configuracion(){
    TRISDbits.RD0 = 0;
    TRISDbits.RD1 = 0;
    TRISDbits.RD2 = 0;
}

out595()
{
    int i=0;
    unsigned char estadopin=0;
    
    reloj =0;
    datapin=0;
    
    for (i=7; i>=0; i--)
    {
        reloj = 0;
        
        if(data595 &(1<<i))
        {
            estadopin = 1;
        }
        else
        {
            estadopin = 0;
        }
        
        datapin = estadopin;
        reloj = 1;
        datapin = 0;
    }
    reloj = 0;
    for (i=7; i>=0; i--)
    {
        reloj = 0;
        
        if(data595_a &(1<<i))
        {
            estadopin = 1;
        }
        else
        {
            estadopin = 0;
        }
        
        datapin = estadopin;
        reloj = 1;
        datapin = 0;
    }
    reloj = 0;
    latch = 1;
    __delay_ms(2);
    latch = 0;
}

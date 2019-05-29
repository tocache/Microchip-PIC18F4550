#pragma config PLLDIV = 1 // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly)) 
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2]) 
#pragma config FOSC = XTPLL_XT // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL)) 
#pragma config PWRT = ON // Power-up Timer Enable bit (PWRT enabled) 
#pragma config BOR = OFF // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software) 
#pragma config WDT = OFF // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit)) 
#pragma config CCP2MX = ON // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1) 
#pragma config PBADEN = OFF // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset) 
#pragma config MCLRE = ON // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled) 
#pragma config LVP = OFF // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled) 

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL

void main(void) {
    //Rutina para que funcione bien el LCD
    TRISD = 0;
    __delay_ms(500);
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_ONOFF(OFF);
    TRISEbits.RE0 = 0;      //Para controlar el servo
    CURSOR_HOME();
    ESCRIBE_MENSAJE("UPC Servo tester",16);
    while(1){
        POS_CURSOR(2,0);
        if(PORTBbits.RB1 == 0 & PORTBbits.RB0 == 0){
            ESCRIBE_MENSAJE("Servo: 000",10);
            ENVIA_CHAR(0xDF);
            LATEbits.LE0 = 1;
            __delay_us(1000);
            LATEbits.LE0 = 0;
            __delay_ms(19);
        }
        else if(PORTBbits.RB1 == 0 & PORTBbits.RB0 == 1){
            ESCRIBE_MENSAJE("Servo: 090",10);
            ENVIA_CHAR(0xDF);
            LATEbits.LE0 = 1;
            __delay_us(1500);
            LATEbits.LE0 = 0;
            __delay_ms(18);
            __delay_us(500);
        }
        else if(PORTBbits.RB1 == 1 & PORTBbits.RB0 == 0){
            ESCRIBE_MENSAJE("Servo: 180",10);
            ENVIA_CHAR(0xDF);
            LATEbits.LE0 = 1;
            __delay_us(2000);
            LATEbits.LE0 = 0;
            __delay_ms(18);
        }
        else if(PORTBbits.RB1 == 1 & PORTBbits.RB0 == 1){
            ESCRIBE_MENSAJE("Servo: 045",10);
            ENVIA_CHAR(0xDF);
            LATEbits.LE0 = 1;
            __delay_us(1250);
            LATEbits.LE0 = 0;
            __delay_ms(18);
            __delay_us(750);            
        }
    }
}

#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"
#define _XTAL_FREQ 48000000UL       //frecuencia de trabajo

//Declaracion de variables globales
unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;
unsigned int cuenta = 0;

unsigned char cadenon[] = "                   Andres Enrique Martin Vasquez Huillcamisa                    ";

unsigned char estado = 0;

void lcd_init(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void init_conf(void){
    INTCON = 0x90;          //Interupciones habilitadas para INT0
}

void main(void){
    init_conf();
    lcd_init();
    ESCRIBE_MENSAJE("     Hola mundo", 15);
    POS_CURSOR(3,0);
    ESCRIBE_MENSAJE("Estado:",7);
    ENVIA_CHAR(estado+0x30);    
    POS_CURSOR(2,0);
    while(1){
        if (estado == 0){
            for(unsigned char i=0;i<60;i++){
                for(unsigned char j=0;j<20;j++){
                    ENVIA_CHAR(cadenon[j+i]);
                }
                __delay_ms(200);
                POS_CURSOR(2,0);
            }
        }
        else{
            for(unsigned char i=0;i<60;i++){
                for(unsigned char j=0;j<20;j++){
                    ENVIA_CHAR(cadenon[j+(60-i)]);
                }
                __delay_ms(200);
                POS_CURSOR(2,0);
            }            
        }
    }
}

void __interrupt(high_priority) INT0_ISR(void){
    if (estado == 0){
        estado = 1;
    }
    else{
        estado = 0;
    }
    POS_CURSOR(3,0);
    ESCRIBE_MENSAJE("Estado:",7);
    ENVIA_CHAR(estado+0x30);
    INTCONbits.INT0IF = 0;
}
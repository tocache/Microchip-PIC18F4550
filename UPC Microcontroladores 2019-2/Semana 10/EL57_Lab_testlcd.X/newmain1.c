//Este es un comentario
//Bits de configuracion o directivas de preprocesador
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC2_PLL3// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
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
#include "LCD.h"
#define _XTAL_FREQ 32000000UL   //Frecuencia de trabajo actual

void main(void) {
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    CURSOR_HOME();
    ADCON1 = 0x0F;
    TRISEbits.RE0 = 0;
    while(1){
        POS_CURSOR(1,0);
        ESCRIBE_MENSAJE("Hola mundo", 10);
        POS_CURSOR(2,0);
        ESCRIBE_MENSAJE("                ", 16);
        while(PORTBbits.RB0 == 1){
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Servo 180 grados", 16);
            LATEbits.LE0 = 1;
            __delay_us(500);
            LATEbits.LE0 = 0;
            __delay_us(19500);
        }
        while(PORTBbits.RB1 == 1){
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Servo 90 grados ", 16);
            LATEbits.LE0 = 1;
            __delay_us(1500);
            LATEbits.LE0 = 0;
            __delay_us(18500);
        }
        while(PORTBbits.RB2 == 1){
            POS_CURSOR(2,0);
            ESCRIBE_MENSAJE("Servo 0 grados  ", 16);
            LATEbits.LE0 = 1;
            __delay_us(2500);
            LATEbits.LE0 = 0;
            __delay_us(17500);
        }
    }
}

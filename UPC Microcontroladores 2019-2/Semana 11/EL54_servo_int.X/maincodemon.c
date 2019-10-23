#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC2_PLL3// System Clock Postscaler Selection bits ([Primary Oscillator Src: /2][96 MHz PLL Src: /3])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = OFF     // CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config LPT1OSC = OFF    // Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#define _XTAL_FREQ 32000000UL
#include <xc.h>
#include "LCD.h"

unsigned char estado = 0;

void arrancaLCD(void){
    TRISD = 0x00;
    LCD_CONFIG();
    __delay_ms(15);
    CURSOR_ONOFF(OFF);
    BORRAR_LCD();
    CURSOR_HOME();
}

void main(void) {
    arrancaLCD();
    ADCON1 = 0x0F;          //Puertos RE como digitales
    TRISEbits.RE0 = 0;           //Puerto RE0 como salida
    INTCONbits.GIE = 1;     //Interruptor global de interrupciones
    INTCONbits.INT0IE = 1;   //Habilitador de INT0
    INTCON3bits.INT1E = 1;  //Habilitador de INT1
    INTCON3bits.INT2IE = 1;  //Habilitador de INT2
    ESCRIBE_MENSAJE("Servito UPC 2019", 16);
    while(1){
        if (estado == 0){
            POS_CURSOR(2, 0);
            ESCRIBE_MENSAJE("Inactivo        ", 16);
        }
        else if (estado == 1){
            POS_CURSOR(2, 0);
            ESCRIBE_MENSAJE("Posicion 0", 10);
            ENVIA_CHAR(0xDF);           //Impresion del simbo9lo del grado
            ESCRIBE_MENSAJE("     ", 5);
            LATEbits.LE0 = 1;
            __delay_us(500);
            LATEbits.LE0 = 0;
            __delay_us(19500);
        }
        else if (estado == 2){
            POS_CURSOR(2, 0);
            ESCRIBE_MENSAJE("Posicion 90", 11);
            ENVIA_CHAR(0xDF);
            ESCRIBE_MENSAJE("    ", 4);
            LATEbits.LE0 = 1;
            __delay_us(1500);
            LATEbits.LE0 = 0;
            __delay_us(18500);
            
        }
        else{
            POS_CURSOR(2, 0);
            ESCRIBE_MENSAJE("Posicion 180", 12);
            ENVIA_CHAR(0xDF);
            ESCRIBE_MENSAJE("   ", 3);
            LATEbits.LE0 = 1;
            __delay_us(2500);
            LATEbits.LE0 = 0;
            __delay_us(17500);
        }
    }
}

void __interrupt() IntsISR(void){
    if (INTCONbits.INT0IF == 1){
        estado = 1;
    }
    else if (INTCON3bits.INT1F == 1){
        estado = 2;
    }
    else{
        estado = 3;
    }
    INTCONbits.INT0IF = 0;      //Bajamos las tres banderas de INTx
    INTCON3bits.INT1IF = 0;
    INTCON3bits.INT2IF = 0;
}
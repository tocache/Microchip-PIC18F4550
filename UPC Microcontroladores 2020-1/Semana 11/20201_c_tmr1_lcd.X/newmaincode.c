/*
 * File:   maincode.c
 * Author: klnla
 *
 * Created on May 19, 2020, 7:59 PM
 */

// PIC18F4550 Configuration Bit Settings
// 'C' source line config statements
#pragma config PLLDIV = 1       // PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
#pragma config CPUDIV = OSC1_PLL2// System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
#pragma config FOSC = XTPLL_XT  // Oscillator Selection bits (XT oscillator, PLL enabled (XTPLL))
#pragma config PWRT = ON        // Power-up Timer Enable bit (PWRT enabled)
#pragma config BOR = OFF        // Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
#pragma config BORV = 3         // Brown-out Reset Voltage bits (Minimum setting 2.05V)
#pragma config WDT = OFF        // Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
#pragma config WDTPS = 32768    // Watchdog Timer Postscale Select bits (1:32768)
#pragma config CCP2MX = ON      // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
#pragma config PBADEN = OFF     // PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
#pragma config MCLRE = ON       // MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)
#pragma config LVP = OFF        // Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)

#include <xc.h>
#include "LCD.h"

#define _XTAL_FREQ 48000000UL   //Frecuencia de trabajo 48MHz

unsigned int d_millar = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

unsigned int ctas_tmr1 = 0;

void convierte(unsigned int numero){
    d_millar = numero / 10000;
    millar = (numero %10000) /1000;
    centena = (numero % 1000) / 100;
    decena =  (numero % 100) / 10;
    unidad = numero % 10;
}

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void configuracion(void) {
    T1CON = 0x03;           //Timer1 ON, PSC 1:1, T1CKI con señal de entrada 32.768KHz
    //Aqui colocas las configuraciones iniciales
}

void main(void) {
    configuracion();
    lcd_init();
    while (1) {
        POS_CURSOR(1, 0);
        ESCRIBE_MENSAJE("Cuentas TMR1:",13);
        ctas_tmr1 = ((TMR1H << 8) + TMR1L);
        convierte(ctas_tmr1);
        POS_CURSOR(2, 0);
        ENVIA_CHAR(d_millar + 0x30); 
        ENVIA_CHAR(millar + 0x30);
        ENVIA_CHAR(centena + 0x30);
        ENVIA_CHAR(decena + 0x30);
        ENVIA_CHAR(unidad + 0x30);    }
}

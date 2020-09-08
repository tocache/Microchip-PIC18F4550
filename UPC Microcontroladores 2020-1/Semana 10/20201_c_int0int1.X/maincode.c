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

void configuracion(void) {
    //Aqui colocare las configuraciones de las interrupciones
    RCONbits.IPEN = 1;          //Habilito las prioridades en las interrupciones
    INTCON3bits.INT1P = 0;      //INT1 como baja prioridad
    INTCON3bits.INT2P = 0;      //INT2 como baja prioridad
    INTCON3bits.INT2IE = 1;     //Habilito la INT2
    INTCON3bits.INT1E = 1;      //Habilito la INT1
    INTCONbits.INT0E = 1;       //Habilito la INT0
    INTCONbits.GIEL = 1;        //Habilito la GIEL
    INTCONbits.GIEH = 1;        //Habilito la GIEH
    TRISB = 0x7F;               //RB7 como salida
}

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void main(void) {
    configuracion();
    lcd_init();
    ESCRIBE_MENSAJE("Presiona boton",14);
    while (1) {
        LATBbits.LB7 = 1;
        __delay_ms(100);
        LATBbits.LB7 = 0;
        __delay_ms(100);
    }
}

void __interrupt(high_priority) Int0_ISR(void) {
    //POS_CURSOR(2,0);
    if (INTCON2bits.INTEDG0 == 1) {
        CURSOR_HOME();
        ESCRIBE_MENSAJE("BTN0 presionado",15); 
        INTCON2bits.INTEDG0 = 0;
    }
    else {
        CURSOR_HOME();
        ESCRIBE_MENSAJE("BTN0 soltado   ",15); 
        INTCON2bits.INTEDG0 = 1;
    }
    INTCONbits.INT0IF = 0;
}

void __interrupt(low_priority) Int1_ISR(void) {
    //POS_CURSOR(2,0);
    if (INTCON3bits.INT1IF == 1) {
        if (INTCON2bits.INTEDG1 == 1) {
            CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN1 presionado",15); 
            INTCON2bits.INTEDG1 = 0;
        }
        else {
            CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN1 soltado   ",15); 
            INTCON2bits.INTEDG1 = 1;
        }
        INTCON3bits.INT1IF = 0;
    }
    if (INTCON3bits.INT2IF == 1) {
        if (INTCON2bits.INTEDG2 == 1) {
            CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN2 presionado",15); 
            INTCON2bits.INTEDG2 = 0;
        }
        else {
            CURSOR_HOME();
            ESCRIBE_MENSAJE("BTN2 soltado   ",15); 
            INTCON2bits.INTEDG2 = 1;
        }
        INTCON3bits.INT2IF = 0;        
    }
}
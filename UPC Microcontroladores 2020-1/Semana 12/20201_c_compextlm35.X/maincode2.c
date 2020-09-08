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

unsigned char normal[] = {"Nivel Normal"};
unsigned char alarma[] = {"Peligro!!!  "};

void lcd_init(void) {
    TRISD = 0x00;               //Puerto RD como salida (esta conectado el LCD)
    LCD_CONFIG();
    __delay_ms(15);
    BORRAR_LCD();
    CURSOR_HOME();
    CURSOR_ONOFF(OFF);
}

void configuracion(void) {
    BAUDCONbits.BRG16 = 1;      //SPBRG en modo 16 bit
    TXSTAbits.BRGH = 1;         //SPBRG en alta velocidad
    TXSTAbits.SYNC = 0;         //SPBRG en modo asíncrono
    SPBRGH = 0x04;              //Establecemos el valor de 1249 en SPBRGH:SPBRG
    SPBRG =  0xE1;
    RCSTAbits.SPEN = 1;         //Habilitamos el puerto serial
    TXSTAbits.TXEN = 1;         //Habilitamos el transmisor
    TRISCbits.RC6 = 0;          //Forzamos a RC6 como salida (para el Tx)
    RCSTAbits.CREN = 1;         //Habilitamos el receptor
    PIE1bits.RCIE = 1;          //Habilitamos interrupción de recepción del EUSART
    INTCONbits.PEIE = 1;        //Habilitamos la interrupción de perifericos
    INTCONbits.GIE = 1;         //Habilitador global de interrupciones
    //Aqui colocas las configuraciones iniciales
    CMCON = 0x16;
    CVRCON = 0xE2;              //Para obtener 0.42V
}

void serial_siguientelinea(void) {
    TXREG = 0x0A;
    while(TXSTAbits.TRMT == 0);
    TXREG = 0x0D;
    while(TXSTAbits.TRMT == 0);        
}

void main(void) {
    configuracion();
    lcd_init();
    while(1) {
        if (CMCONbits.C1OUT == 1) {
            for (unsigned int i=0;i<12;i++){
                TXREG = alarma[i];
                while(TXSTAbits.TRMT == 0);
            }
            serial_siguientelinea(); 
            POS_CURSOR(1,0);
            ESCRIBE_MENSAJE(alarma, 12);
        }
        else {
            for (unsigned int i=0;i<12;i++){
                TXREG = normal[i];
                while(TXSTAbits.TRMT == 0);
            }
            serial_siguientelinea();
            POS_CURSOR(1,0);        
            ESCRIBE_MENSAJE(normal, 12);
        }
        __delay_ms(500);        
    }

}

void __interrupt() RCIsr(void) {
    PIR1bits.RCIF = 0;              //Bajamos la bandera de interrupcion
}    

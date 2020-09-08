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

unsigned int res_ad0 = 0;
unsigned int res_ad1 = 0;
unsigned int millar = 0;
unsigned int centena = 0;
unsigned int decena = 0;
unsigned int unidad = 0;

void convierte(unsigned int numero){
    millar = numero /1000;
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
    //Aqui colocas las configuraciones iniciales
    ADCON2 = 0xA4;               //ADFM=0 (just derecha), 8TAD, Fosc/4
    ADCON1 = 0x0E;              //Canal AN0 habilitado
    ADCON0 = 0x01;              //Canal AN0 seleccionado y encendemos el A/D
    lcd_init();
}

void main(void) {
    configuracion();
    ESCRIBE_MENSAJE("VIRTUALASO",10);
    while (1) {
        //Tu programa de usuario
        ADCON0bits.CHS3 = 0;
        ADCON0bits.CHS2 = 0;
        ADCON0bits.CHS1 = 0;
        ADCON0bits.CHS0 = 0;
        ADCON0bits.GODONE = 1;           //Inicio una captura de mueestra en AN0
        while(ADCON0bits.GODONE == 1);   //Espero a que termine de convertir
        POS_CURSOR(2,0);                //Siguiente linea
        ESCRIBE_MENSAJE("C0:",3);
        res_ad0 = (ADRESH << 8) + ADRESL;
        convierte(res_ad0);              //Sacar los dígitos
        ENVIA_CHAR(millar+0x30);        //Escribo el numero millar en caracter ASCII
        ENVIA_CHAR(centena+0x30);       //Escribo el numero centena en caracter ASCII
        ENVIA_CHAR(decena+0x30);        //Escribo el numero decena en caracter ASCII
        ENVIA_CHAR(unidad+0x30);        //Escribo el numero unidad en caracter ASCII

        ADCON0bits.CHS3 = 0;
        ADCON0bits.CHS2 = 0;
        ADCON0bits.CHS1 = 0;
        ADCON0bits.CHS0 = 1;
        ADCON0bits.GODONE = 1;           //Inicio una captura de mueestra en AN0
        while(ADCON0bits.GODONE == 1);   //Espero a que termine de convertir
        ESCRIBE_MENSAJE(" C1:",4);
        res_ad1 = (ADRESH << 8) + ADRESL;
        convierte(res_ad1);              //Sacar los dígitos
        ENVIA_CHAR(millar+0x30);        //Escribo el numero millar en caracter ASCII
        ENVIA_CHAR(centena+0x30);       //Escribo el numero centena en caracter ASCII
        ENVIA_CHAR(decena+0x30);        //Escribo el numero decena en caracter ASCII
        ENVIA_CHAR(unidad+0x30);        //Escribo el numero unidad en caracter ASCII        
    }
}
